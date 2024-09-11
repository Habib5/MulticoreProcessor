`ifndef M_WB_IF_VH
`define M_WB_IF_VH

//all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface m_wb_if;
 
    word_t ALUout_in,  instr_in,  npc_in,  dmemload_in,
           ALUout_out, instr_out, npc_out, dmemload_out; 
    
    logic [15:0] imm_in,
                 imm_out;

    logic [4:0] rd_in,  rt_in,
                rd_out, rt_out;

    logic [1:0] regDest_in,
                regDest_out;

    //flags
    logic imemREN_in,  JAL_in,  LUI_in,  halt_in,  memToReg_in,  regWrite_in,
          imemREN_out, JAL_out, LUI_out, halt_out, memToReg_out, regWrite_out;

    //standalones
    logic ihit, dhit_in,
                dhit_out;

    modport mwb(
        input ALUout_in, instr_in, npc_in, dmemload_in, imm_in, rd_in, rt_in, regDest_in, imemREN_in, JAL_in, LUI_in, halt_in, memToReg_in, regWrite_in, ihit, dhit_in,
        output ALUout_out, instr_out, npc_out, dmemload_out, imm_out, rd_out, rt_out, regDest_out, imemREN_out, JAL_out, LUI_out, halt_out, memToReg_out, regWrite_out, dhit_out
    );

    modport tb(
        output ALUout_in, instr_in, npc_in, dmemload_in, imm_in, rd_in, rt_in, regDest_in, imemREN_in, JAL_in, LUI_in, halt_in, memToReg_in, regWrite_in, ihit, dhit_in,
        input ALUout_out, instr_out, npc_out, dmemload_out, imm_out, rd_out, rt_out, regDest_out, imemREN_out, JAL_out, LUI_out, halt_out, memToReg_out, regWrite_out, dhit_out
    );

endinterface

`endif //M_WB_IF_VH