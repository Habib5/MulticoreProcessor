`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1 ns

module control_unit_tb;
    parameter PERIOD = 10;
    logic CLK = 0, nRST;
    // clock
    always #(PERIOD/2) CLK++;

    control_unit_if cuif ();
    test PROG (CLK, nRST);

    //DUT
`ifndef MAPPED
  control_unit DUT(cuif);
`else
  control_unit DUT(
.\cuif.instr (cuif.instr),
.\cuif.aluop (cuif.aluop),
.\cuif.rs (cuif.rs),
.\cuif.rt (cuif.rt),
.\cuif.rd (cuif.rd),
.\cuif.imm (cuif.imm),
.\cuif.ALUSrc (cuif.ALUSrc),
.\cuif.regDest (cuif.regDest),
.\cuif.jumpAddr (cuif.jumpAddr),
.\cuif.PCSrc (cuif.PCSrc),
.\cuif.regWrite (cuif.regWrite),
.\cuif.imemREN (cuif.imemREN),
.\cuif.dREN (cuif.dREN),
.\cuif.dWEN (cuif.dWEN),
.\cuif.J (cuif.J),
.\cuif.JAL (cuif.JAL),
.\cuif.memToReg (cuif.memToReg),
.\cuif.extOp (cuif.extOp),
.\cuif.funct (cuif.funct),
.\cuif.shamt (cuif.shamt),
.\cuif.halt (cuif.halt)
  );
`endif
endmodule

program test(
    input logic CLK,
    output logic nRST
);

task reset_DUT();
  @(negedge CLK);
  nRST = 1'b0;

  @(posedge CLK);

  nRST = 1'b1;

  @(posedge CLK);
  @(negedge CLK);
endtask

initial
begin
    //add registers 2 and 3, store into 4 RTYPE
    cuif.instr = 32'h00432020;
    repeat (10)
    begin
        @(posedge CLK);
    end

    //lw $2, 100($3) I TYPE
    cuif.instr = 32'h8C620064;
    repeat (10)
    begin
        @(posedge CLK);
    end

    //J to addr 0xF0 J TYPE
    cuif.instr = 32'h080000F0;
    repeat (10)
    begin
        @(posedge CLK);
    end
    
    

    $finish;
end

endprogram