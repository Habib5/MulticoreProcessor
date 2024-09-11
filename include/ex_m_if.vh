`ifndef EX_M_IF_VH
`define EX_M_IF_VH

//all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface ex_m_if;

    word_t rdat2_in,  npc_in,  instr_in,  ALUout_in,
           rdat2_out, npc_out, instr_out, ALUout_out;

    logic [15:0] imm_in,
                 imm_out;

    logic [4:0] rt_in,  rd_in,
                rt_out, rd_out;

    logic [1:0] regDest_in,
                regDest_out;

    //flags
    logic halt_in,  dREN_in,  dWEN_in,  imemREN_in,  regWrite_in,  memToReg_in,  JAL_in,  LUI_in,  
          halt_out, dREN_out, dWEN_out, imemREN_out, regWrite_out, memToReg_out, JAL_out, LUI_out;
    //standalones
    logic ihit, dhit;

    modport exm(
        input rdat2_in, npc_in, instr_in, ALUout_in, imm_in, rt_in, rd_in, regDest_in, halt_in, dREN_in, dWEN_in, imemREN_in, regWrite_in, memToReg_in, JAL_in, LUI_in, ihit, dhit,
        output rdat2_out, npc_out, instr_out, ALUout_out, imm_out, rt_out, rd_out, regDest_out, halt_out, dREN_out, dWEN_out, imemREN_out, regWrite_out, memToReg_out, JAL_out, LUI_out
    );

    modport tb(
        output rdat2_in, npc_in, instr_in, ALUout_in, imm_in, rt_in, rd_in, regDest_in, halt_in, dREN_in, dWEN_in, imemREN_in, regWrite_in, memToReg_in, JAL_in, LUI_in, ihit, dhit,
        input rdat2_out, npc_out, instr_out, ALUout_out, imm_out, rt_out, rd_out, regDest_out, halt_out, dREN_out, dWEN_out, imemREN_out, regWrite_out, memToReg_out, JAL_out, LUI_out
    );

endinterface

`endif //EX_M_IF_VH