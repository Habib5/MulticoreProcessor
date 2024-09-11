`ifndef D_EX_IF_VH
`define D_EX_IF_VH

//all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface d_ex_if;


    word_t rdat1_in,  rdat2_in,  npc_in,  instr_in, 
           rdat1_out, rdat2_out, npc_out, instr_out;

    aluop_t ALUOp_in,
            ALUOp_out;

    logic [25:0] immJ_in,
                 immJ_out;

    logic [15:0] imm_in,
                 imm_out;

    logic [4:0] rs_in,  rt_in,  rd_in,
                rs_out, rt_out, rd_out;

    logic [1:0] ALUSrc_in,  regDest_in,  jumpAddr_in,
                ALUSrc_out, regDest_out, jumpAddr_out;

    //flags
    logic dREN_in,  dWEN_in,  imemREN_in,  JAL_in,  BNE_in,  LUI_in,  halt_in,  memToReg_in,  regWrite_in,  branch_in,
          dREN_out, dWEN_out, imemREN_out, JAL_out, BNE_out, LUI_out, halt_out, memToReg_out, regWrite_out, branch_out,
          freeze;

    //standalones
    logic flush, ihit, dhit;

    modport dex(
        input rdat1_in, rdat2_in, npc_in, instr_in, ALUOp_in, immJ_in, imm_in, rs_in, rt_in, rd_in, ALUSrc_in, regDest_in, jumpAddr_in,dREN_in, 
            dWEN_in, imemREN_in, JAL_in, BNE_in, LUI_in, halt_in, memToReg_in, regWrite_in, branch_in, flush, ihit, dhit, freeze, 
        output rdat1_out, rdat2_out, npc_out, instr_out, ALUOp_out, immJ_out, imm_out, rs_out, rt_out, rd_out, ALUSrc_out, regDest_out, jumpAddr_out, 
            dREN_out, dWEN_out, imemREN_out, JAL_out, BNE_out, LUI_out, halt_out, memToReg_out, regWrite_out, branch_out
    );

    modport tb(
        output rdat1_in, rdat2_in, npc_in, instr_in, ALUOp_in, immJ_in, imm_in, rs_in, rt_in, rd_in, ALUSrc_in, regDest_in, jumpAddr_in, dREN_in, 
            dWEN_in, imemREN_in, JAL_in, BNE_in, LUI_in, halt_in, memToReg_in, regWrite_in, branch_in,
        input rdat1_out, rdat2_out, npc_out, instr_out, ALUOp_out, immJ_out, imm_out, rs_out, rt_out, rd_out, ALUSrc_out, regDest_out, jumpAddr_out, 
            dREN_out, dWEN_out, imemREN_out, JAL_out, BNE_out, LUI_out, halt_out, memToReg_out, regWrite_out, branch_out
    );

endinterface

`endif //D_EX_IF_VH