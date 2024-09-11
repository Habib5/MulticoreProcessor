`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

//all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface hazard_unit_if;

    word_t instr_dec, instr_ex, instr_mem;
    logic flush, freeze_fd, freeze_dex, branch, bne, zero_flag, mem_regwrite, dhit;
    logic [1:0] jump_sel;
    regbits_t rs_dec, rt_dec, rt_ex, rd_ex, rt_mem, rd_mem, rw_memory;

    modport hu(
        input instr_dec, instr_ex, instr_mem, branch, bne, zero_flag, mem_regwrite, rs_dec, rt_dec, rt_ex, rd_ex, rt_mem, rd_mem, jump_sel, rw_memory, dhit,
        output freeze_fd, freeze_dex, flush
    );

    modport tb(
        output instr_dec, instr_ex, instr_mem, branch, bne, zero_flag, mem_regwrite, rs_dec, rt_dec, rt_ex, rd_ex, rt_mem, rd_mem, jump_sel, rw_memory, dhit,
        input freeze_fd, freeze_dex, flush
    );

endinterface

`endif 
