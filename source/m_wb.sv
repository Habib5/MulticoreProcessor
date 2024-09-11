
/*
    modport mwb(
        input ALUout_in, instr_in, npc_in, dmemload_in, imm_in, rd_in, rt_in, regDest_in, imemREN_in, JAL_in, LUI_in, halt_in, memToReg_in, regWrite_in, ihit, dhit_in,
        output ALUout_out, instr_out, npc_out, dmemload_out, imm_out, rd_out, rt_out, regDest_out, imemREN_out, JAL_out, LUI_out, halt_out, memToReg_out, regWrite_out, dhit_out;
    );
    */

`include "m_wb_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module m_wb(
    input logic clk, nRST,
    m_wb_if.mwb mwb
);

//ihit not used yet
//now it is

always_ff @ (posedge clk, negedge nRST)
    if (~nRST) begin
        mwb.ALUout_out <= '0;
        mwb.instr_out <= '0;
        mwb.npc_out <= '0;
        mwb.dmemload_out <= '0;
        mwb.imm_out <= '0;
        mwb.rd_out <= '0;
        mwb.rt_out <= '0;
        mwb.regDest_out <= '0;
        mwb.imemREN_out <= 1;
        mwb.JAL_out <= '0;
        mwb.LUI_out <= '0;
        mwb.halt_out <= '0;
        mwb.memToReg_out <= '0;
        mwb.regWrite_out <= '0;
        mwb.dhit_out <= '0;
    end
    else if (mwb.ihit || mwb.dhit_in) begin
        mwb.ALUout_out <= mwb.ALUout_in;
        mwb.instr_out <= mwb.instr_in;
        mwb.npc_out <= mwb.npc_in;
        mwb.dmemload_out <= mwb.dmemload_in;
        mwb.imm_out <= mwb.imm_in;
        mwb.rd_out <= mwb.rd_in;
        mwb.rt_out <= mwb.rt_in;
        mwb.regDest_out <= mwb.regDest_in;
        mwb.imemREN_out <= mwb.imemREN_in;
        mwb.JAL_out <= mwb.JAL_in;
        mwb.LUI_out <= mwb.LUI_in;
        mwb.halt_out <= mwb.halt_in;
        mwb.memToReg_out <= mwb.memToReg_in;
        mwb.regWrite_out <= mwb.regWrite_in;
        mwb.dhit_out <= mwb.dhit_in;
    end

endmodule
