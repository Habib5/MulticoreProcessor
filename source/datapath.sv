//include everything
`include "register_file_if.vh"
`include "alu_if.vh"
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"

//latch interfaces
`include "f_d_if.vh"
`include "d_ex_if.vh"
`include "ex_m_if.vh"
`include "m_wb_if.vh"

//include hazard and fwd
`include "hazard_unit_if.vh"
`include "forwarding_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  
  // pc init
  parameter PC_INIT = 0;

  //initialize everything
  register_file_if rfif();
  alu_if aluif();
  control_unit_if cuif();
  f_d_if fdif();
  d_ex_if dexif();
  ex_m_if exmif();
  m_wb_if mwbif();
  hazard_unit_if huif();
  forwarding_unit_if fuif();

  //DUTS
  register_file RF(CLK, nRST, rfif);
  alu ALU(CLK, nRST, aluif);
  control_unit CU(cuif);

  //latches
  f_d IFID(CLK,nRST,fdif);
  d_ex IDEX(CLK,nRST,dexif);
  ex_m EXMEM(CLK,nRST,exmif);
  m_wb MEMWB(CLK,nRST,mwbif);

  //hazard unit and forwarding unit
  hazard_unit HAZUN(huif); //ADD MODPORT WHEN YOU SYN
  forwarding_unit FUN(fuif);

  //internal to datapath
  word_t rdat1, rdat2, jaddr, baddr, pc, next_pc, npc, signedext, zeroext;

  //sequential order

  //PC Stuff
  always_comb
  begin
    zeroext = {16'h0000, cuif.imm};
      //next_pc
    if (dexif.jumpAddr_out == 2'b00)
      next_pc = npc;
    else if (dexif.jumpAddr_out == 2'b01)
      next_pc = jaddr;
    else if (dexif.jumpAddr_out == 2'b10)
      next_pc = dexif.rdat1_out;
    else
      next_pc = baddr;
  end
  
  //program counter
  always_ff @ (posedge CLK, negedge nRST)
      if(!nRST)
          pc <= PC_INIT;
      else
          if(dpif.ihit && ~huif.freeze_fd)
              pc <= next_pc;
              
  //npc logic
  always_comb
      npc = pc + 4;

  //f_d latch done
  always_comb begin : IFIDLatch
    fdif.instr_in = dpif.imemload;
    fdif.npc_in = npc;
    fdif.ihit = dpif.ihit;
    fdif.flush = huif.flush;
    fdif.freeze = huif.freeze_fd;
  end
 
  //Register File Stuff done
  always_comb
  begin
    rfif.WEN = mwbif.regWrite_out;
    rfif.rsel1 = cuif.rs;
    rfif.rsel2 = cuif.rt;

    if (mwbif.regDest_out == 2'b00)
      rfif.wsel = mwbif.rd_out;
    else if (mwbif.regDest_out == 2'b01)
      rfif.wsel = mwbif.rt_out;
    else
      rfif.wsel = 32'hffff;

    if (mwbif.LUI_out)
      rfif.wdat = {mwbif.imm_out, 16'h0};
    else if (mwbif.JAL_out)
      rfif.wdat = mwbif.npc_out;
    else if (mwbif.memToReg_out)
      rfif.wdat = mwbif.dmemload_out;
    else
      rfif.wdat = mwbif.ALUout_out;
  end
  
  //Control Unit Stuff done
  always_comb
  begin
    cuif.instr = fdif.instr_out;
  end

  //Hazard Unit Stuff
  always_comb begin
    //input instr_in, branch, bne, zero_flag, mem_regwrite, rs, rt, rw, jump_sel,
    //output freeze, flush
    huif.instr_dec = fdif.instr_out;
    huif.instr_ex = dexif.instr_out;
    huif.instr_mem = exmif.instr_out;
    huif.branch = dexif.branch_out;
    huif.bne = dexif.BNE_out;
    huif.zero_flag = aluif.zero;
    huif.mem_regwrite = exmif.regWrite_out;
    huif.rs_dec = cuif.rs;
    huif.rt_dec = cuif.rt;
    huif.rt_ex = dexif.rt_out;
    huif.rd_ex = dexif.rd_out;
    huif.rt_mem = exmif.rt_out;
    huif.rd_mem = exmif.rd_out;
    huif.jump_sel = dexif.jumpAddr_out;
    huif.rw_memory = fuif.rw_mem_reg;
    huif.dhit = dpif.dhit;

  end

  //d_ex latch done
  always_comb begin : IDEXLatch
    dexif.instr_in = fdif.instr_out; //(waves)
    dexif.rdat1_in = rfif.rdat1;
    dexif.rdat2_in = rfif.rdat2;
    dexif.npc_in = fdif.npc_out;
    dexif.ALUOp_in = cuif.aluop;
    dexif.immJ_in = cuif.immJ; 
    dexif.imm_in = cuif.imm;
    dexif.rs_in = cuif.rs;
    dexif.rt_in = cuif.rt;
    dexif.rd_in = cuif.rd;
    dexif.ALUSrc_in = cuif.ALUSrc;
    dexif.regDest_in = cuif.regDest;
    dexif.jumpAddr_in = cuif.jumpAddr;
    dexif.dREN_in = cuif.dREN;
    dexif.dWEN_in = cuif.dWEN;
    dexif.imemREN_in = cuif.imemREN;
    dexif.JAL_in = cuif.JAL;
    dexif.BNE_in = cuif.BNE;
    dexif.LUI_in = cuif.LUI;
    dexif.halt_in = cuif.halt;
    dexif.memToReg_in = cuif.memToReg;
    dexif.regWrite_in = cuif.regWrite;
    dexif.branch_in = cuif.branch;
    dexif.flush = huif.flush;
    dexif.ihit = dpif.ihit;
    dexif.dhit = dpif.dhit;
    dexif.freeze = huif.freeze_dex;
  end

  //ALU Stuff done
  always_comb
  begin
    if (fuif.rdat1_f)
      rdat1 = fuif.rs_new;
    else 
      rdat1 = dexif.rdat1_out;

    if (fuif.rdat2_f)
      rdat2 = fuif.rt_new;
    else 
      rdat2 = dexif.rdat2_out;

    aluif.aluop = dexif.ALUOp_out;
    aluif.a = rdat1; //for future forwarding
    aluif.b = rdat2; //catch latch

    if (dexif.ALUSrc_out == 2'b00)
      aluif.b = rdat2;
    else if (dexif.ALUSrc_out == 2'b10)
      aluif.b = dexif.imm_out[15] ? {16'hffff, dexif.imm_out} : {16'h0, dexif.imm_out};
    else if (dexif.ALUSrc_out == 2'b01)
      aluif.b = {16'h0, dexif.imm_out};
  end
  
  //forwarding unit stuff
  always_comb
  begin
    fuif.rs = dexif.rs_out;
    fuif.rt = dexif.rt_out;

    fuif.rw_mem = exmif.regWrite_out;
    fuif.rw_wb = mwbif.regWrite_out;

    if (mwbif.JAL_in)
      fuif.data_mem = mwbif.npc_in;
    else if (mwbif.LUI_in)
      fuif.data_mem = {mwbif.imm_in, 16'b0};
    else
      fuif.data_mem = mwbif.ALUout_in;

    fuif.data_wb = rfif.wdat;
    
    //0 = rd, 1 = rt, 2 = r31, do regdest-in for mem then regdest-out for wb
    if (mwbif.regDest_in == 0)
      fuif.rw_mem_reg = mwbif.rd_in;
    else if (mwbif.regDest_in == 1)
      fuif.rw_mem_reg = mwbif.rt_in;
    else
      fuif.rw_mem_reg = 5'd31;

    if (mwbif.regDest_out == 0)
      fuif.rw_wb_reg = mwbif.rd_out;
    else if (mwbif.regDest_out == 1)
      fuif.rw_wb_reg = mwbif.rt_out;
    else
      fuif.rw_wb_reg = 5'd31;  
  end


  //ex_m latch done
  always_comb begin : EXMEMLatch
    exmif.instr_in = dexif.instr_out; //(waves)
    exmif.rdat2_in = rdat2;
    exmif.npc_in = dexif.npc_out;
    exmif.ALUout_in = aluif.out;
    exmif.imm_in = dexif.imm_out;
    exmif.rt_in = dexif.rt_out;
    exmif.rd_in = dexif.rd_out;
    exmif.regDest_in = dexif.regDest_out;
    exmif.halt_in = dexif.halt_out;
    exmif.dREN_in = dexif.dREN_out;
    exmif.dWEN_in = dexif.dWEN_out;
    exmif.imemREN_in = dexif.imemREN_out;
    exmif.regWrite_in = dexif.regWrite_out;
    exmif.memToReg_in = dexif.memToReg_out;
    exmif.JAL_in = dexif.JAL_out;
    exmif.LUI_in = dexif.LUI_out;
    exmif.ihit = dpif.ihit;
    exmif.dhit = dpif.dhit;
  end

logic [13:0] signext;
assign signext = dexif.imm_out[15] ? '1 : '0;

  always_comb begin

    baddr = huif.flush ? (dexif.npc_out + {signext, dexif.imm_out, 2'b00}) : npc;

    jaddr = {dexif.npc_out[31:28], dexif.immJ_out, 2'b00};
  end

  
  //m_wb latch done
  always_comb begin : MEMWBLatch
    mwbif.instr_in = exmif.instr_out; //(waves)
    mwbif.ALUout_in = exmif.ALUout_out;
    mwbif.npc_in = exmif.npc_out;
    mwbif.dmemload_in = dpif.dmemload;
    mwbif.imm_in = exmif.imm_out;
    mwbif.rd_in = exmif.rd_out;
    mwbif.rt_in = exmif.rt_out;
    mwbif.regDest_in = exmif.regDest_out;
    mwbif.imemREN_in = exmif.imemREN_out;
    mwbif.JAL_in = exmif.JAL_out;
    mwbif.LUI_in = exmif.LUI_out;
    mwbif.halt_in = exmif.halt_out;
    mwbif.memToReg_in = exmif.memToReg_out;
    mwbif.regWrite_in = exmif.regWrite_out;
    mwbif.ihit = dpif.ihit;
    mwbif.dhit_in = dpif.dhit;
  end
  
  //feedback from end, wrap around stuff done
  always_comb begin
    dpif.imemREN = 1;
    dpif.dmemWEN = exmif.dWEN_out;
    dpif.dmemREN = exmif.dREN_out;
    dpif.dmemstore = exmif.rdat2_out;
    dpif.dmemaddr = exmif.ALUout_out;
    dpif.imemaddr = pc;
  end

  //halt 
  always_ff @(posedge CLK, negedge nRST)
  begin
    if (~nRST)
      dpif.halt <= 0;
    else if (mwbif.halt_in)
      dpif.halt <= mwbif.halt_in;
  end

  //caches
  //nothing extra needed

  //LL and SC
  always_comb begin
    if ((exmif.instr_out[31:26] == LL) || (exmif.instr_out[31:26] == SC))
      dpif.datomic = 1;
    else
      dpif.datomic = 0;
  end
  
endmodule

