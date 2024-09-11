`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module request_unit(
    input logic CLK, nRST,
    request_unit_if.ru ru
    //ihit, dhit, dWEN, dREN are INPUTS 
    //dmemREN, dmemWEN are OUTPUTS
);
//dhit high means turn off the corresponding signal

always_ff @ (posedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        ru.dmemREN <= 0;
        ru.dmemWEN <= 0; 
    end
    else if (ru.dhit == 1)
    begin
        ru.dmemREN <= 0;
        ru.dmemWEN <= 0; 
    end
    else if (ru.ihit == 1)
    begin
        ru.dmemREN <= ru.dREN;
        ru.dmemWEN <= ru.dWEN; 
    end
    //else retain
end

always_comb
begin
    ru.pcen = ru.ihit; 
end

endmodule
