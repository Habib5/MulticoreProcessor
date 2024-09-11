
/*
    modport exm(
        input rdat2_in, npc_in, instr_in, ALUout_in, imm_in, rt_in, rd_in, regDest_in, halt_in, dREN_in, dWEN_in, imemREN_in, regWrite_in, memToReg_in, JAL_in, LUI_in, ihit, dhit;
        output rdat2_out, npc_out, instr_out, ALUout_out, imm_out, rt_out, rd_out, regDest_out, halt_out, dREN_out, dWEN_out, imemREN_out, regWrite_out, memToReg_out, JAL_out, LUI_out;
    );
    */

`include "ex_m_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module ex_m(
    input logic clk, nRST,
    ex_m_if.exm exm
);

always_ff @ (posedge clk, negedge nRST)
    if (~nRST) begin
        exm.rdat2_out <= '0;
        exm.npc_out <= '0;
        exm.instr_out <= '0;
        exm.ALUout_out <= '0;
        exm.imm_out <= '0;
        exm.rt_out <= '0;
        exm.rd_out <= '0;
        exm.regDest_out <= '0;
        exm.halt_out <= '0;
        exm.dREN_out <= '0;
        exm.dWEN_out <= '0;
        exm.imemREN_out <= 1;
        exm.regWrite_out <= '0;
        exm.memToReg_out <= '0;
        exm.JAL_out <= '0;
        exm.LUI_out <= '0;
    end
    //also not sure about this dhit
    else if (exm.dhit) begin
        exm.rdat2_out <= '0;
        exm.npc_out <= '0;
        exm.instr_out <= '0;
        exm.ALUout_out <= '0;
        exm.imm_out <= '0;
        exm.rt_out <= '0;
        exm.rd_out <= '0;
        exm.regDest_out <= '0;
        exm.halt_out <= '0;
        exm.dREN_out <= '0;
        exm.dWEN_out <= '0;
        exm.imemREN_out <= 1;
        exm.regWrite_out <= '0;
        exm.memToReg_out <= '0;
        exm.JAL_out <= '0;
        exm.LUI_out <= '0;
    end
    else if (exm.ihit) begin
        exm.rdat2_out <= exm.rdat2_in;
        exm.npc_out <= exm.npc_in;
        exm.instr_out <= exm.instr_in;
        exm.ALUout_out <= exm.ALUout_in;
        exm.imm_out <= exm.imm_in;
        exm.rt_out <= exm.rt_in;
        exm.rd_out <= exm.rd_in;
        exm.regDest_out <= exm.regDest_in;
        exm.halt_out <= exm.halt_in;
        exm.dREN_out <= exm.dREN_in;
        exm.dWEN_out <= exm.dWEN_in;
        exm.imemREN_out <= exm.imemREN_in;
        exm.regWrite_out <= exm.regWrite_in;
        exm.memToReg_out <= exm.memToReg_in;
        exm.JAL_out <= exm.JAL_in;
        exm.LUI_out <= exm.LUI_in;
    end

endmodule