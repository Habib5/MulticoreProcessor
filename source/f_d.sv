/*
        input flush, ihit, instr_in, npc_in, 
        output instr_out, npc_out
*/
`include "f_d_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module f_d (
    input logic clk, nRST,
    f_d_if.fd fd
);

//flush and ihit not used yet
// now it is

always_ff @ (posedge clk, negedge nRST)
    if (~nRST) begin
        fd.instr_out <= '0;
        fd.npc_out <= '0;
    end
    else if (fd.ihit && fd.flush) begin
        fd.instr_out <= '0;
        fd.npc_out <= '0;
    end
    else if (fd.ihit && ~fd.freeze) begin // freeze or flush is probably the culprit
        fd.instr_out <= fd.instr_in;
        fd.npc_out <= fd.npc_in;
    end

endmodule
