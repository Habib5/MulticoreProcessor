`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module register_file (
    input logic CLK,
    input logic nRST,
    register_file_if.rf rf
);

word_t [31:0] registerNum; 

always_ff @ (negedge CLK, negedge nRST)
begin
    if (!nRST)
    begin
        for (int i = 0; i < 32; i++)
        begin
            registerNum[i] <= '0;
        end
    end
    else
    begin
        if (rf.WEN)
        begin
            if (rf.wsel != 5'b0)
                registerNum[rf.wsel] <= rf.wdat;
            else
                registerNum[rf.wsel] <= '0;
        end 
    end
end

always_comb
begin
    rf.rdat1 = registerNum[rf.rsel1];
    rf.rdat2 = registerNum[rf.rsel2];
end

endmodule