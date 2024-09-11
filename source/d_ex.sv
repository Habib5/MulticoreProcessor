
`include "cpu_types_pkg.vh"
`include "d_ex_if.vh"
import cpu_types_pkg::*;

/*
        input rdat1_in, rdat2_in, npc_in, instr_in, ALUOp_in, immJ_in, imm_in, rs_in, rt_in, rd_in, ALUSrc_in, regDest_in, jumpAddr_in,dREN_in, 
            dWEN_in, imemREN_in, JAL_in, BNE_in, LUI_in, halt_in, memToReg_in, regWrite_in, branch_in,
        output rdat1_out, rdat2_out, npc_out, outstr_out, ALUOp_out, immJ_out, imm_out, rs_out, rt_out, rd_out, ALUSrc_out, regDest_out, jumpAddr_out, 
            dREN_out, dWEN_out, imemREN_out, JAL_out, BNE_out, LUI_out, halt_out, memToReg_out, regWrite_out, branch_out;
*/

module d_ex(
    input logic clk, nRST,
    d_ex_if.dex dex
);

always_ff @(posedge clk, negedge nRST)
    if (~nRST) begin
        dex.rdat1_out <= '0;
        dex.rdat2_out <= '0;
        dex.npc_out <= '0;
        dex.instr_out <= '0;
        dex.ALUOp_out <= ALU_SLL;
        dex.immJ_out <= '0;
        dex.imm_out <= '0;
        dex.rs_out <= '0;
        dex.rt_out <= '0;
        dex.rd_out <= '0;
        dex.ALUSrc_out <= '0;
        dex.regDest_out <= '0;
        dex.jumpAddr_out <= '0;
        dex.dREN_out <= '0;
        dex.dWEN_out <= '0;
        dex.imemREN_out <= 1;
        dex.JAL_out <= '0;
        dex.BNE_out <= '0;
        dex.LUI_out <= '0;
        dex.halt_out <= '0;
        dex.memToReg_out <= '0;
        dex.regWrite_out <= '0;
        dex.branch_out <= '0;
    end
    //not sure about the freeze here
    //else if (~dex.freeze && dex.ihit && dex.flush) begin 
    //else if (dex.freeze || (dex.ihit && dex.flush)) begin
    else if (dex.ihit && (dex.flush || dex.freeze)) begin 
        dex.rdat1_out <= '0;
        dex.rdat2_out <= '0;
        dex.npc_out <= '0;
        dex.instr_out <= '0;
        dex.ALUOp_out <= ALU_SLL;
        dex.immJ_out <= '0;
        dex.imm_out <= '0;
        dex.rs_out <= '0;
        dex.rt_out <= '0;
        dex.rd_out <= '0;
        dex.ALUSrc_out <= '0;
        dex.regDest_out <= '0;
        dex.jumpAddr_out <= '0;
        dex.dREN_out <= '0;
        dex.dWEN_out <= '0;
        dex.imemREN_out <= 1;
        dex.JAL_out <= '0;
        dex.BNE_out <= '0;
        dex.LUI_out <= '0;
        dex.halt_out <= '0;
        dex.memToReg_out <= '0;
        dex.regWrite_out <= '0;
        dex.branch_out <= '0;
    end
    else if (~dex.freeze && dex.ihit) begin 
    //else if (dex.ihit) begin
        dex.rdat1_out <= dex.rdat1_in;
        dex.rdat2_out <= dex.rdat2_in;
        dex.npc_out <= dex.npc_in;
        dex.instr_out <= dex.instr_in;
        dex.ALUOp_out <= dex.ALUOp_in;
        dex.immJ_out <= dex.immJ_in;
        dex.imm_out <= dex.imm_in;
        dex.rs_out <= dex.rs_in;
        dex.rt_out <= dex.rt_in;
        dex.rd_out <= dex.rd_in;
        dex.ALUSrc_out <= dex.ALUSrc_in;
        dex.regDest_out <= dex.regDest_in;
        dex.jumpAddr_out <= dex.jumpAddr_in;
        dex.dREN_out <= dex.dREN_in;
        dex.dWEN_out <= dex.dWEN_in;
        dex.imemREN_out <= dex.imemREN_in;
        dex.JAL_out <= dex.JAL_in;
        dex.BNE_out <= dex.BNE_in;
        dex.LUI_out <= dex.LUI_in;
        dex.halt_out <= dex.halt_in;
        dex.memToReg_out <= dex.memToReg_in;
        dex.regWrite_out <= dex.regWrite_in;
        dex.branch_out <= dex.branch_in;
    end

endmodule
