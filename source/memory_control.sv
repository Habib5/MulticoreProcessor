// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

typedef enum logic[3:0] {
  IDLE, ARBITRATE, INSTR, WB1, WB2, SNOOP, ALL1, ALL2, CACHE1, CACHE2
} states;
states state, next_state;

logic snoopdogg, stash, next_snoopdogg, next_stash; //snoopdogg tells cc to snoop into stash

always_ff @(posedge CLK, negedge nRST) begin
  if(~nRST) begin
     state <= IDLE;
     snoopdogg <= 0;
     stash <= 1;
  end else begin
     state <= next_state;
     snoopdogg <= next_snoopdogg;
     stash <= next_stash;
  end
end

//next state
always_comb begin 
  next_state = state;
  next_snoopdogg = snoopdogg;
  next_stash = stash;
  
  case(state)
    IDLE: begin
      if (ccif.dWEN[0] || ccif.dWEN[1]) 
        next_state = WB1;
      else if (ccif.cctrans[0] || ccif.cctrans[1]) 
        next_state = ARBITRATE;
      else if (ccif.iREN[0] || ccif.iREN[1]) 
        next_state = INSTR;
    end
    ARBITRATE: begin
      if(ccif.dREN[0] || ccif.dREN[1]) begin
        next_state = SNOOP;
        if(ccif.dREN[0]) begin
          next_snoopdogg = 0;
          next_stash = 1;
        end else if (ccif.dREN[1]) begin
          next_snoopdogg = 1;
          next_stash = 0;
        end
      end else begin
        next_state = IDLE;
      end
    end
    INSTR: begin
      if (ccif.ramstate == ACCESS) begin
        if (ccif.cctrans == 0)
          next_state = IDLE;
        else
          next_state = ARBITRATE;
      end
      if (ccif.dWEN[0] || ccif.dWEN[1]) 
        next_state = WB1;
    end
    WB1: begin
      if (ccif.ramstate == ACCESS) 
        next_state = WB2;
    end
    WB2: begin
      if (ccif.ramstate == ACCESS) 
        next_state = IDLE;
    end
    SNOOP: begin
      if(ccif.cctrans[stash])
        next_state = CACHE1;
      else
        next_state = ALL1;
    end
    ALL1: begin
      if (ccif.ramstate == ACCESS) 
        next_state = ALL2;
    end
    ALL2: begin
      if (ccif.ramstate == ACCESS) 
        next_state = IDLE;
    end
    CACHE1: begin
      if (ccif.ramstate == ACCESS) 
        next_state = CACHE2;
    end
    CACHE2: begin
      if (ccif.ramstate == ACCESS) 
        next_state = IDLE;
    end
  endcase
end

//output
always_comb begin
  ccif.iwait[0] = 1;
  ccif.iwait[1] = 1;
  ccif.dwait[0] = 1;
  ccif.dwait[1] = 1; 

  ccif.iload[0] = 0;
  ccif.iload[1] = 0;
  ccif.dload[0] = 0;
  ccif.dload[1] = 0; 

  ccif.ramWEN = 0;
  ccif.ramREN = 0;
  ccif.ramaddr = '0;
  ccif.ramstore = '0;
  
  ccif.ccsnoopaddr[0] = '0;
  ccif.ccsnoopaddr[1] = '0; 
  ccif.ccwait[0] = 0;
  ccif.ccwait[1] = 0; 

  ccif.ccinv[0] = ccif.ccwrite[1];
  ccif.ccinv[1] = ccif.ccwrite[0];  

  case(state)
    ARBITRATE: begin
      ccif.ccwait[next_stash] = 1;
      ccif.ccsnoopaddr[next_stash] = ccif.daddr[snoopdogg];
    end
    SNOOP: begin
      ccif.ccsnoopaddr[stash] = ccif.daddr[snoopdogg];
      ccif.ccwait[stash] = 1;
    end
    ALL1: begin
      ccif.ramaddr = ccif.daddr[snoopdogg];
      ccif.ramREN = ccif.dREN[snoopdogg];
      ccif.dload[snoopdogg] = ccif.ramload;
      ccif.ccwait[stash] = 1;

      if (ccif.ramstate == ACCESS)
        ccif.dwait[snoopdogg] = 0;
      else
        ccif.dwait[snoopdogg] = 1;
    end
    ALL2: begin
      ccif.ramaddr = ccif.daddr[snoopdogg];
      ccif.ramREN = ccif.dREN[snoopdogg];
      ccif.dload[snoopdogg] = ccif.ramload;
      ccif.ccwait[stash] = 1;

      if (ccif.ramstate == ACCESS)
        ccif.dwait[snoopdogg] = 0;
      else
        ccif.dwait[snoopdogg] = 1;
    end
    CACHE1: begin
      ccif.ramaddr = ccif.daddr[stash];
      ccif.ramstore = ccif.dstore[stash];
      ccif.ramWEN = 1;
      ccif.dload[snoopdogg] = ccif.dstore[stash];
      ccif.ccsnoopaddr[stash] = ccif.daddr[snoopdogg];
      ccif.ccwait[stash] = 1;

      if (ccif.ramstate == ACCESS) begin
        ccif.dwait[snoopdogg] = 0;
        ccif.dwait[stash] = 0;
      end
      else begin
        ccif.dwait[snoopdogg] = 1;
        ccif.dwait[stash] = 1;
      end
    end
    CACHE2: begin
      ccif.ramaddr = ccif.daddr[stash];
      ccif.ramstore = ccif.dstore[stash];
      ccif.ramWEN = 1;
      ccif.dload[snoopdogg] = ccif.dstore[stash];
      ccif.ccsnoopaddr[stash] = ccif.daddr[snoopdogg];
      ccif.ccwait[stash] = 1;

      if (ccif.ramstate == ACCESS) begin
        ccif.dwait[snoopdogg] = 0;
        ccif.dwait[stash] = 0;
      end
      else begin
        ccif.dwait[snoopdogg] = 1;
        ccif.dwait[stash] = 1;
      end
    end
    INSTR: begin
      if(ccif.iREN[1]) begin
        ccif.ramaddr = ccif.iaddr[1];
        ccif.ramREN = ccif.iREN[1];
        ccif.iload[1] = ccif.ramload;

        if (ccif.ramstate == ACCESS)
          ccif.iwait[1] = 0;
        else
          ccif.iwait[1] = 1;
      end 
      else if (ccif.iREN[0]) begin
        ccif.ramaddr = ccif.iaddr[0];
        ccif.ramREN = ccif.iREN[0];
        ccif.iload[0] = ccif.ramload;
        
        if (ccif.ramstate == ACCESS)
          ccif.iwait[0] = 0;
        else
          ccif.iwait[0] = 1;
      end
    end
    WB1: begin
      if(ccif.dWEN[1]) begin
        ccif.ramaddr = ccif.daddr[1];
        ccif.ramWEN = ccif.dWEN[1];
        ccif.ramstore = ccif.dstore[1];
        ccif.ccwait[0] = 1;
        if (ccif.ramstate == ACCESS)
          ccif.dwait[1] = 0;
        else
          ccif.dwait[1] = 1;
      end 
      else if (ccif.dWEN[0]) begin
        ccif.ramaddr = ccif.daddr[0];
        ccif.ramWEN = ccif.dWEN[0];
        ccif.ramstore = ccif.dstore[0];
        ccif.ccwait[1] = 0;
        if (ccif.ramstate == ACCESS)
          ccif.dwait[0] = 0;
        else
          ccif.dwait[0] = 1;
      end
    end
    WB2: begin
      if(ccif.dWEN[1]) begin
        ccif.ramaddr = ccif.daddr[1];
        ccif.ramWEN = ccif.dWEN[1];
        ccif.ramstore = ccif.dstore[1];
        ccif.ccwait[0] = 1;

        if (ccif.ramstate == ACCESS)
          ccif.dwait[1] = 0;
        else
          ccif.dwait[1] = 1;
      end 
      else if (ccif.dWEN[0]) begin
        ccif.ramaddr = ccif.daddr[0];
        ccif.ramWEN = ccif.dWEN[0];
        ccif.ramstore = ccif.dstore[0];
        ccif.ccwait[1] = 0;

        if (ccif.ramstate == ACCESS)
          ccif.dwait[0] = 0;
        else
          ccif.dwait[0] = 1;
      end
    end
  endcase 
end
endmodule 