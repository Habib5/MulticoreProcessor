`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

//all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface forwarding_unit_if;

    word_t rs_new, rt_new, data_mem, data_wb;  
    regbits_t rs, rt;
    regbits_t rw_mem_reg, rw_wb_reg;

    logic rw_mem, rw_wb;
    logic rdat1_f, rdat2_f; //flags


    modport fu(
        input rs, rt, rw_mem, rw_wb, rw_mem_reg, rw_wb_reg, data_mem, data_wb,
        output rs_new, rt_new, rdat1_f, rdat2_f
    );

    modport tb(
        output rs, rt, rw_mem, rw_wb, rw_mem_reg, rw_wb_reg, data_mem, data_wb,
        input rs_new, rt_new, rdat1_f, rdat2_f
    );

endinterface

`endif 
