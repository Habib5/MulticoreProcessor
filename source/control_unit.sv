// interface include
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module control_unit (
  control_unit_if.cu cu
);

always_comb
begin
    //use for waves
    opcode_t opcode;
    funct_t func;
    opcode = opcode_t'(cu.instr[31:26]);
    func = funct_t'(cu.instr[5:0]);

    cu.aluop = ALU_SLL; //is all 0's
    // cu.rs = '0;
    // cu.rt = '0;
    // cu.rd = '0;
    cu.imm = '0;
    cu.ALUSrc = '0; 
    cu.regDest = '0;
    cu.jumpAddr = '0; 
    cu.branch = '0;
    cu.regWrite = '0; 
    cu.imemREN = 1;
    cu.dREN = '0;
    cu.dWEN = '0;
    cu.J = '0; //dont need this
    cu.JAL = '0;
    cu.memToReg = '0; 
    cu.funct = '0;
    cu.shamt = '0;
    cu.halt = '0;
    cu.BNE = '0;
    cu.LUI = '0;
    cu.immJ = '0;

    cu.rs = cu.instr[25:21];
    cu.rt = cu.instr[20:16];
    cu.rd = cu.instr[15:11];

    cu.imm = cu.instr[15:0];
    cu.immJ = cu.instr[25:0];

    
    //rtype, then 2 jtypes, then else the itypes
    if (cu.instr[31:26] == RTYPE)
    begin
        cu.regDest = 2'b00;

        case (cu.instr[5:0])
            ADDU:
            begin
                cu.aluop = ALU_ADD;
                cu.regWrite = 1;
            end
            ADD:
            begin
                cu.aluop = ALU_ADD;
                cu.regWrite = 1;
            end
            AND:
            begin
                cu.aluop = ALU_AND;
                cu.regWrite = 1;
            end
            JR:
            begin
                cu.jumpAddr = 2'b10; 
            end
            NOR:
            begin
                cu.aluop = ALU_NOR;
                cu.regWrite = 1;
            end
            OR:
            begin
                cu.aluop = ALU_OR;
                cu.regWrite = 1;
            end
            SLT:
            begin
                cu.aluop = ALU_SLT;
                cu.regWrite = 1;
            end
            SLTU:
            begin
                cu.aluop = ALU_SLTU;
                cu.regWrite = 1;
            end
            SLLV:
            begin
                cu.aluop = ALU_SLL;
                cu.regWrite = 1;
            end
            SRLV:
            begin
                cu.aluop = ALU_SRL;
                cu.regWrite = 1;
            end
            SUBU:
            begin
                cu.aluop = ALU_SUB;
                cu.regWrite = 1;
            end
            SUB:
            begin
                cu.aluop = ALU_SUB;
                cu.regWrite = 1;
            end
            XOR:
            begin
                cu.aluop = ALU_XOR;
                cu.regWrite = 1;
            end
        endcase
    end
    else if (cu.instr[31:26] == J)
    begin
        cu.jumpAddr = 2'b01; 
    end
    else if (cu.instr[31:26] == JAL)
    begin
        cu.regDest = 2'b10;
        cu.JAL = 1;
        cu.regWrite = 1;
        cu.jumpAddr = 2'b01; 
    end
    else //finish with itype
        cu.regDest = 2'b01;

        //10 is sign extended
        //01 is zero extended

        case (cu.instr[31:26])
            ADDIU:
            begin
                cu.aluop = ALU_ADD;
                cu.ALUSrc = 2'b10;
                cu.regWrite = 1;
            end
            ADDI:
            begin
                cu.aluop = ALU_ADD;
                cu.ALUSrc = 2'b10;
                cu.regWrite = 1;
            end
            ANDI:
            begin
                cu.aluop = ALU_AND;
                cu.ALUSrc = 2'b01;
                cu.regWrite = 1;                
            end
            BEQ:
            begin
                cu.aluop = ALU_SUB;
                cu.branch = 1;
                cu.jumpAddr = 2'b11;
            end
            BNE:
            begin
                cu.aluop = ALU_SUB;
                cu.branch = 1;
                cu.jumpAddr = 2'b11;
                cu.BNE = 1;                
            end
            LUI:
            begin
                cu.LUI = 1;
                cu.regWrite = 1;
            end
            LW:
            begin
                cu.aluop = ALU_ADD;
                cu.memToReg = 1;
                cu.ALUSrc = 2'b10;
                cu.dREN = 1;
                cu.regWrite = 1;
            end
            ORI:
            begin
                cu.aluop = ALU_OR;
                cu.ALUSrc = 2'b01;
                cu.regWrite = 1;
            end
            SLTI:
            begin
                cu.aluop = ALU_SLT;
                cu.ALUSrc = 2'b10;
                cu.regWrite = 1;
            end
            SLTIU:
            begin
                cu.aluop = ALU_SLTU;
                cu.ALUSrc = 2'b10;
                cu.regWrite = 1;
            end
            SW:
            begin
                cu.aluop = ALU_ADD;
                cu.ALUSrc = 2'b10;
                cu.dWEN = 1;
                cu.regWrite = 0;
            end
            XORI:
            begin
                cu.aluop = ALU_XOR;
                cu.ALUSrc = 2'b01;
                cu.regWrite = 1;
            end
            HALT:
            begin
                cu.halt = 1;
            end
            LL:
            begin
                cu.aluop = ALU_ADD;
                cu.ALUSrc = 2'b10;
                cu.memToReg = 1;
                cu.dREN = 1;
            end
            SC:
            begin
                cu.aluop = ALU_ADD;
                cu.ALUSrc = 2'b10;
                cu.memToReg = 1;
                cu.dWEN = 1;
                cu.regWrite = 1;
            end
        endcase

end

endmodule