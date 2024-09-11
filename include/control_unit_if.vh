`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface control_unit_if;
    word_t instr;
    aluop_t aluop;
    regbits_t rs,rt,rd;
    logic [25:0] immJ;
    logic [15:0] imm;
    logic [1:0] ALUSrc; //1. rdat2 (00), 2. zero ext (01), or 3. sign ext (10) else!! 
    logic [1:0] regDest; //. rd (00), 2. rt (01), or 3. JAL (31) (10) else!!
    logic [1:0] jumpAddr; //used in that big 3 way mux, 1. pc/npc, 2. j/jal, 3. jr 4. branch
    logic branch; //into AND gate w zero flag
    logic regWrite;
    logic imemREN;
    logic dREN, dWEN;
    logic J, JAL; //dont need J
    logic memToReg;
    logic extOp; //dont need
    logic funct; //dont need
    logic shamt; //dont need
    logic halt;
    logic LUI;
    logic BNE;

    modport cu (
        input instr,
        output aluop, rs, rt, rd, imm, ALUSrc, regDest, jumpAddr, branch, regWrite, imemREN, dREN, dWEN, J, JAL, memToReg, extOp, funct, shamt, halt, LUI, BNE, immJ
    );

    modport tb (
        output instr,
        input aluop, rs, rt, rd, imm, ALUSrc, regDest, jumpAddr, branch, regWrite, imemREN, dREN, dWEN, J, JAL, memToReg, funct, shamt, halt, LUI, BNE, immJ
    );

endinterface

`endif //CONTROL_UNIT_IF_VH