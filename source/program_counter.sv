`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module program_counter(
    input logic CLK, nRST,
    program_counter_if.pc2 pc
);

//need to import huif.freeze here
always_ff @ (posedge CLK, negedge nRST)
begin
    if(!nRST)
    begin
        pc.pc <= '0;
    end
    else
    begin
        if(pc.pcen)
        begin
            pc.pc <= pc.next_pc;
        end
    end 
end

always_comb
begin
    pc.npc = pc.pc + 4;
end
endmodule