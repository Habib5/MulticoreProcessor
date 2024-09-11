`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"
import cpu_types_pkg::*; 

module forwarding_unit 
(
  forwarding_unit_if.fu fuif
);

always_comb begin : rs_rdat1
    if (fuif.rw_mem == 1 && (fuif.rs == fuif.rw_mem_reg))
    begin
        fuif.rdat1_f = 1;
        fuif.rs_new = fuif.data_mem;
    end
    else if (fuif.rw_wb == 1 && (fuif.rs == fuif.rw_wb_reg))
    begin
        fuif.rdat1_f = 1;
        fuif.rs_new = fuif.data_wb;
    end
    else
    begin
        fuif.rdat1_f = '0;
        fuif.rs_new = '0;
    end
end
// 0.5
always_comb begin : rt_rdat2
    if (fuif.rw_mem == 1 && (fuif.rt == fuif.rw_mem_reg))
    begin
        fuif.rdat2_f = 1;
        fuif.rt_new = fuif.data_mem;
    end
    else if (fuif.rw_wb == 1 && (fuif.rt == fuif.rw_wb_reg))
    begin
        fuif.rdat2_f = 1;
        fuif.rt_new = fuif.data_wb;
    end
    else
    begin
        fuif.rdat2_f = '0;
        fuif.rt_new = '0;
    end
end


endmodule
