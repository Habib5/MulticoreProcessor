`ifndef F_D_IF_VH
`define F_D_IF_VH

//all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface f_d_if;

    word_t instr_in, instr_out, npc_in, npc_out;
    logic flush, ihit, freeze;

    modport fd(
        input flush, ihit, instr_in, npc_in, freeze,
        output instr_out, npc_out
    );

    modport fdhz(
        input instr_out, npc_out
    );

    modport tb(
        output flush, ihit, instr_in, npc_in,
        input instr_out, npc_out
    );

endinterface

`endif //F_D_IF_VH
