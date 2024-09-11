`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1 ns



module memory_control_tb;
    parameter PERIOD = 10;
    logic CLK = 0, nRST;
    // clock
    always #(PERIOD/2) CLK++;

    caches_if cif0 ();
    caches_if cif1 ();
    cache_control_if #(.CPUS(2)) ccif (cif0, cif1);

    test PROG (CLK, nRST, ccif);

    //DUT
`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
`else
  memory_control DUT(
.\ccif.iREN (dcif.iREN),
.\ccif.iaddr (dcif.iaddr),
.\ccif.dREN (dcif.dmemREN),
.\ccif.dWEN (dcif.dWEN),
.\ccif.dstore (dcif.dstore),
.\ccif.daddr (dcif.daddr),
.\ccif.dwait (cif.dwait),
.\ccif.dload (cif.dload),
.\ccif.iwait (cif.iwait),
.\ccif.iload (cif.iload),
.\ccif.ramWEN(ccif.ramWEN),
.\ccif.ramREN(ccif.ramREN),
.\ccif.ramstore(ccif.ramstore),
.\ccif.ramload(ccif.ramload),
.\ccif.ramstate(ccif.ramstate),
.\ccif.ramaddr(ccif.ramaddr),
.\nRST (nRST),
.\CLK (CLK)
  );
`endif
endmodule

program test(
    input logic CLK,
    output logic nRST,
    cache_control_if ccif
);
  typedef enum logic [3:0] {
    IDLE, ARBITRATE, INSTR, SNOOP, WB1, WB2, CACHE1, CACHE2, RAMLOAD1, RAMLOAD2
} states;
    states expected;

task reset_DUT();
  @(negedge CLK);
  nRST = 1'b0;

  @(posedge CLK);

  nRST = 1'b1;
  /////////////////
  expected = IDLE;

  cif0.iREN = 0;
  cif0.iaddr = '0;
  cif0.dREN = 0;
  cif0.dWEN = 0;
  cif0.daddr = '0;;
  cif0.dstore = '0;
  cif0.ccwrite = 0;
  cif0.cctrans = 0;

  cif1.iREN = 0;
  cif1.iaddr = '0;
  cif1.dREN = 0;
  cif1.dWEN = 0;
  cif1.daddr = '0;
  cif1.dstore = '0;
  cif1.ccwrite = 0;
  cif1.cctrans = 0;

  ccif.ramstate = ACCESS;
  ccif.ramload = 0;
  /////////////////
  @(posedge CLK);
  @(negedge CLK);
endtask

string tb_test_case;
int tb_test_case_num;

initial
begin
    //initialization
    expected = IDLE;

    cif0.iREN = 0;
    cif0.iaddr = '0;
    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.daddr = '0;;
    cif0.dstore = '0;
    cif0.ccwrite = 0;
    cif0.cctrans = 0;

    cif1.iREN = 0;
    cif1.iaddr = '0;
    cif1.dREN = 0;
    cif1.dWEN = 0;
    cif1.daddr = '0;
    cif1.dstore = '0;
    cif1.ccwrite = 0;
    cif1.cctrans = 0;

    ccif.ramstate = ACCESS;
    ccif.ramload = 0;

    nRST = 1;
    reset_DUT();

    @(posedge CLK);
    @(posedge CLK);

    tb_test_case = "Initial";
    tb_test_case_num = -1;

    //1
    tb_test_case = "From IDLE, Assert dWEN -> WB1";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    cif0.dWEN = 1;
    repeat (5)
      @(posedge CLK);

    //state should be WB1

    //2
    tb_test_case = "From IDLE, Assert cctrans -> ARBITRATE";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    cif0.cctrans = 1;    
    repeat (5)
      @(posedge CLK);

    //state should be ARBITRATE


    //3
    tb_test_case = "From IDLE, Assert iREN -> INSTR";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    cif0.iREN = 1;    
    repeat (5)
      @(posedge CLK);

    //state should be INSTR

    //4
    tb_test_case = "From IDLE, to WB1 to WB2 to IDLE";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    cif0.dWEN = 1;    
    @(posedge CLK);
    @(negedge CLK);
    //state should be WB1
    expected = WB1;
    cif0.dWEN = 0;   

    @(posedge CLK);
    @(negedge CLK);
    //state should be WB2
    expected = WB2;

    @(posedge CLK);
    @(negedge CLK);
    //state should be IDLE
    expected = IDLE;

    @(posedge CLK);
    @(negedge CLK);

    //5
    tb_test_case = "From IDLE, to INSTR to WB1 to WB2 to IDLE";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    cif0.iREN = 1;   
    @(posedge CLK);
    @(negedge CLK);

    expected = INSTR;
    cif0.iREN = 0;
    cif0.dWEN = 1;

    @(posedge CLK);
    @(negedge CLK);
    //state should be WB1
    expected = WB1;
    cif0.dWEN = 0;   

    @(posedge CLK);
    @(negedge CLK);
    //state should be WB2
    expected = WB2;

    @(posedge CLK);
    @(negedge CLK);
    //state should be IDLE
    expected = IDLE;

    @(posedge CLK);
    @(negedge CLK);



    //6
    tb_test_case = "From IDLE, to ARBITRATE to snoop to cache1 to cache2 to IDLE";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    cif0.cctrans = 1;   
    @(posedge CLK);
    @(negedge CLK);

    expected = ARBITRATE;
    cif0.cctrans = 0;
    cif0.dREN = 1;

    @(posedge CLK);
    @(negedge CLK);
 
    expected = SNOOP;
    cif0.dREN = 0;

    @(posedge CLK);
    @(negedge CLK);

    expected = CACHE1;

    @(posedge CLK);
    @(negedge CLK);

    expected = CACHE2;

    @(posedge CLK);
    @(negedge CLK);

    expected = IDLE;

    @(posedge CLK);
    @(negedge CLK);

    $finish;
end
endprogram

// `include "cache_control_if.vh"
// `include "caches_if.vh"
// `include "cpu_ram_if.vh"
// `include "cpu_types_pkg.vh"

// `timescale 1 ns / 1 ns

// import cpu_types_pkg::*;
// module memory_control_tb;

//   parameter PERIOD = 10;

//   parameter CPUS = 1;
  
//   logic CLK = 0, nRST;

//   // clock
//   always #(PERIOD/2) CLK++;

//   // interface
//   caches_if cif0 ();
//   caches_if cif1 ();
//   cpu_ram_if crif ();
//   cache_control_if #(.CPUS(CPUS)) ccif (cif0, cif1);
//   // test program
//   test PROG (CLK, nRST, cif0, ccif);
//   // DUT
// `ifndef MAPPED
//   memory_control DUT(CLK, nRST, ccif);
// `else
//   memory_control DUT(
//     .\ccif.iREN (ccif.iREN),
//     .\ccif.dREN (ccif.dREN),
//     .\ccif.dWEN (ccif.dWEN),
//     .\ccif.dstore (ccif.dstore),
//     .\ccif.iaddr (ccif.iaddr),
//     .\ccif.daddr (ccif.daddr),
//     .\ccif.ramload (ccif.ramload),
//     .\ccif.ramstate (ccif.ramstate),
//     .\ccif.iwait (ccif.iwait),
//     .\ccif.dwait (ccif.dwait),
//     .\ccif.iload (ccif.iload),
//     .\ccif.dload (ccif.dload),
//     .\ccif.ramstore (ccif.ramstore),
//     .\ccif.ramaddr (ccif.ramaddr),
//     .\ccif.ramWEN (ccif.ramWEN),
//     .\ccif.ramREN (ccif.ramREN),

//     .\nRST (nRST),
//     .\CLK (CLK)
//   );
// `endif

// `ifndef MAPPED
//   ram ram(CLK, nRST, crif);
// `else
//   ram ram(
//     .\crif.ramload (crif.ramload),
//     .\crif.ramstate (crif.ramstate),
//     .\crif.ramstore (crif.ramstore),
//     .\crif.ramaddr (crif.ramaddr),
//     .\crif.ramWEN (crif.ramWEN),
//     .\crif.ramREN (crif.ramREN),
    
//     .\nRST (nRST),
//     .\CLK (CLK)
//   );
// `endif

// //have to assign crifs to ccifs
// assign ccif.ramload = crif.ramload;   
// assign ccif.ramstate = crif.ramstate;
// assign crif.ramstore = ccif.ramstore;
// assign crif.ramaddr = ccif.ramaddr;
// assign crif.ramREN = ccif.ramREN;
// assign crif.ramWEN = ccif.ramWEN;

// endmodule

// program test (
//     input logic CLK,
//     output logic nRST,
//     caches_if.caches cif,
//     cache_control_if.cc ccif
    
// );

// task reset_DUT();
//   @(negedge CLK);
//   nRST = 1'b0;

//   @(posedge CLK);

//   nRST = 1'b1;

//   @(posedge CLK);
//   @(negedge CLK);
// endtask

// task automatic dump_memory();
//     string filename = "memcpu.hex";
//     int memfd;

//     //cif0.tbCTRL = 1;
//     cif.daddr = 0;
//     cif.dWEN = 0;
//     cif.dREN = 0;

//     memfd = $fopen(filename,"w");
//     if (memfd)
//       $display("Starting memory dump.");
//     else
//       begin $display("Failed to open %s.",filename); $finish; end

//     for (int unsigned i = 0; memfd && i < 16384; i++)
//     begin
//       int chksum = 0;
//       bit [7:0][7:0] values;
//       string ihex;

//       cif.daddr = i << 2;
//       cif.dREN = 1;
//       repeat (4) @(posedge CLK);
//       if (cif.dload === 0)
//         continue;
//       values = {8'h04,16'(i),8'h00,cif.dload};
//       foreach (values[j])
//         chksum += values[j];
//       chksum = 16'h100 - chksum;
//       ihex = $sformatf(":04%h00%h%h",16'(i),cif.dload,8'(chksum));
//       $fdisplay(memfd,"%s",ihex.toupper());
//     end //for
//     if (memfd)
//     begin
//       //cif0.tbCTRL = 0;
//       cif.dREN = 0;
//       $fdisplay(memfd,":00000001FF");
//       $fclose(memfd);
//       $display("Finished memory dump.");
//     end
//   endtask

// //end of tasks/////////////////////////////////////////////////////////////////////////////////

// string tb_test_case;
// int tb_test_case_num;
// int i;

// initial begin
//   $monitor("iload = %h, daddr = %0h, dstore = %0h", 
//     cif0.iload, cif0.daddr, cif0.dstore);
  
//   @(posedge CLK);
//   @(posedge CLK);

//   tb_test_case = "Initial";
//   tb_test_case_num = -1;

//   cif.iREN = '0;
//   cif.dREN = '0;
//   cif.dWEN = '0;
//   cif.dstore = '0;
//   cif.iaddr = '0;
//   cif.daddr = '0;

//   reset_DUT();

//   $display("Initialization");
//   //1, Read Instuctions from RAM ///////////////////////////////////////////////////////////////
//   tb_test_case = "I Read";
//   tb_test_case_num = tb_test_case_num + 1;
//   reset_DUT();

//   cif.iREN = 1;
//   cif.dREN = '0;
//   cif.dWEN = '0;
//   cif.dstore = '0;
//   cif.iaddr = '0;
//   cif.daddr = '0;

//   @(posedge CLK);
//   @(posedge CLK);

//   assert (ccif.ramload == cif.iload)
//     $display("Test case %s successful", tb_test_case);
//   else 
//     $display("not successful on test %s", tb_test_case);

//   @(posedge CLK);
//   @(posedge CLK);

//   //2, Read Data from RAM ///////////////////////////////////////////////////////////////
//   tb_test_case = "D Read";
//   tb_test_case_num = tb_test_case_num + 1;
//   reset_DUT();

//   cif.iREN = '0;
//   cif.dREN = 1;
//   cif.dWEN = '0;
//   cif.dstore = '0;
//   cif.iaddr = '0;
//   cif.daddr = 32'h4;

//   @(posedge CLK);
//   @(posedge CLK);

//   assert (ccif.ramload == cif.dload)
//     $display("Test case %s successful", tb_test_case);
//   else 
//     $display("not successful on test %s", tb_test_case);

//   @(posedge CLK);
//   @(posedge CLK);
  
//   //3, Write Data to RAM ///////////////////////////////////////////////////////////////
//   tb_test_case = "D Write";
//   tb_test_case_num = tb_test_case_num + 1;
//   reset_DUT();

//   cif.iREN = '0;
//   cif.dREN = '0;
//   cif.dWEN = 1;
//   cif.dstore = 32'h12345678;
//   cif.iaddr = '0;
//   cif.daddr = 32'h8;

//   @(posedge CLK);
//   @(posedge CLK);

//   assert (ccif.ramload == cif.dstore)
//     $display("Test case %s successful", tb_test_case);
//   else 
//     $display("not successful on test %s", tb_test_case);

//   @(posedge CLK);
//   @(posedge CLK);

//   //4, Conflicting I Read and D Read ///////////////////////////////////////////////////////////////
//   tb_test_case = "Conflicting iRead dRead";
//   tb_test_case_num = tb_test_case_num + 1;
//   reset_DUT();

//   cif.iREN = 1;
//   cif.dREN = 1;
//   cif.dWEN = '0;
//   cif.dstore = 32'h12345678;
//   cif.iaddr = '0;
//   cif.daddr = 32'h4;

//   @(posedge CLK);
//   @(posedge CLK);

//   assert (ccif.ramload == cif.dload)
//     $display("Test case %s successful", tb_test_case);
//   else 
//     $display("not successful on test %s", tb_test_case);

//   @(posedge CLK);
//   @(posedge CLK);

//   //5, Conflicting I Read and D Write ///////////////////////////////////////////////////////////////
//   tb_test_case = "Conflicting iRead dWrite";
//   tb_test_case_num = tb_test_case_num + 1;
//   reset_DUT();

//   cif.iREN = 1;
//   cif.dREN = '0;
//   cif.dWEN = 1;
//   cif.dstore = 32'h12345678;
//   cif.iaddr = '0;
//   cif.daddr = 32'h4;

//   @(posedge CLK);
//   @(posedge CLK);

//   assert (ccif.ramstore == cif.dstore)
//     $display("Test case %s successful", tb_test_case);
//   else 
//     $display("not successful on test %s", tb_test_case);

//   @(posedge CLK);
//   @(posedge CLK);

//   //dump memory
//   dump_memory();
//   $finish;

// end
// endprogram
