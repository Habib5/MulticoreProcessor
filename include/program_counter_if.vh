`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface program_counter_if;

    word_t pc, next_pc, npc;
    logic pcen;

    modport pc2 (
        input pcen, next_pc,
        output pc, npc
    );

    modport tb (
        input pc, npc,
        output pcen, next_pc
    );

endinterface

`endif //PROGRAM_COUNTER_IF_VH