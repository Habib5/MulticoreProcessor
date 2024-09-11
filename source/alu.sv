`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module alu (
    input logic CLK, nRST, 
    alu_if.rf rf
);

always_comb begin : ALUoperations
    rf.out = '0;
    rf.negative = 0;
    rf.overflow = 0;
    rf.zero = 0;

    case(rf.aluop)
    ALU_SLL:  begin rf.out = rf.b << rf.a[4:0]; end
    ALU_SRL:  begin rf.out = rf.b >> rf.a[4:0]; end
    ALU_ADD:  begin rf.out = rf.a + rf.b;  end
    ALU_SUB:  begin rf.out = rf.a - rf.b;  end
    ALU_AND:  begin rf.out = rf.a & rf.b;  end
    ALU_OR:   begin rf.out = rf.a | rf.b;  end
    ALU_XOR:  begin rf.out = rf.a ^ rf.b;  end
    ALU_NOR:  begin rf.out = ~(rf.a|rf.b); end
    // ALU_SLT:  begin rf.out = (signed'(rf.a) < signed'(rf.b)); end //switch out for faster operation
    ALU_SLT:  begin if (!rf.b[31] && !rf.a[31]) rf.out = (rf.a) < (rf.b);
                else if (rf.b[31] && rf.a[31]) rf.out = (rf.a) > (rf.b); 
                else rf.out = (rf.a[31]); end //switch out for faster operation
    ALU_SLTU: begin rf.out = rf.a < rf.b; end
    endcase

    rf.negative = rf.out[31];
    rf.zero = ~(|rf.out);

    //overflow

    // if (rf.aluop == ALU_ADD) //addition
    // begin
    //     if (!(rf.a[31]) && !(rf.b[31]))
    //         rf.overflow = rf.out[31];
    //     else if ((rf.a[31]) && (rf.b[31]))
    //         rf.overflow = !(rf.out[31]);
    //     else 
    //         rf.overflow = 0;
    // end
    // else if (rf.aluop == ALU_SUB) //subtraction
    // begin
    //     if (!(rf.a[31]) && (rf.b[31]))
    //         rf.overflow = rf.out[31];
    //     else if ((rf.a[31]) && !(rf.b[31]))
    //         rf.overflow = !(rf.out[31]);
    //     else
    //         rf.overflow = 0;
    // end
    // else
    //     rf.overflow = 0;

    casez (rf.aluop)
        ALU_ADD:  rf.overflow = (rf.a[31] == rf.b[31]) && (rf.out[31] != rf.a[31]);
        ALU_SUB:  rf.overflow = (rf.a[31] == rf.b[31]) && !(rf.out[31] != rf.a[31]);
    endcase
end

endmodule