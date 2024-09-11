// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;
module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif);
  // DUT
`ifndef MAPPED
  alu DUT(CLK, nRST, rfif);
`else
  alu DUT(
    .\rf.overflow (rfif.overflow),
    .\rf.negative (rfif.negative),
    .\rf.zero (rfif.zero),
    .\rf.out (rfif.out),
    .\rf.aluop (rfif.aluop),
    .\rf.a (rfif.a),
    .\rf.b (rfif.b),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test (
    input logic CLK,
    output logic nRST,
    alu_if.tb tb
);

task reset_DUT();
  @(negedge CLK);

  nRST = 1'b0;

  //@(posedge CLK);
  @(posedge CLK);

  nRST = 1'b1;

  //@(posedge CLK);
  @(posedge CLK);

  @(negedge CLK);
endtask

string tb_test_case;
int tb_test_case_num;

initial begin
  $monitor("a = %b b = %0d, out = %0d", 
    tb.a, tb.b, tb.out);

  tb.aluop = ALU_ADD;
  tb.a = '0;
  tb.b = '0;
  reset_DUT();
  
  @(posedge CLK);
  @(posedge CLK);

  tb_test_case = "Initial";
  tb_test_case_num = -1;
  $display("Initialization");
  //1, SLL ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "SLL";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h1;
  tb.b = 32'h00000100;
  tb.aluop = ALU_SLL;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.b << tb.a))) 
    $display("Test case %s successfulUntitled Diagram.drawio", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //2, SRL ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "SRL";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h1;
  tb.b = 32'h00001000;
  tb.aluop = ALU_SRL;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.b >> tb.a))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //3, ADD ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "ADD";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h1;
  tb.b = 32'h1;
  tb.aluop = ALU_ADD;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.a + tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //4, SUB ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "SUB";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h10;
  tb.b = 32'h1;
  tb.aluop = ALU_SUB;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.a - tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //5, AND ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "AND";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h0101;
  tb.b = 32'h101;
  tb.aluop = ALU_AND;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.a & tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //6, OR ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "OR";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h0101;
  tb.b = 32'h1010;
  tb.aluop = ALU_OR;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.a | tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);
  @(posedge CLK);
  @(posedge CLK);

  //7, XOR ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "XOR";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h10101;
  tb.b = 32'h10010;
  tb.aluop = ALU_XOR;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.a ^ tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //8, NOR ////////////////////////////////////////////////////////////////////////////
  tb_test_case = "NOR";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h0011;
  tb.b = 32'h0101;
  tb.aluop = ALU_NOR;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == ~(tb.a | tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //9, SLT////////////////////////////////////////////////////////////////////////////
  tb_test_case = "SLT";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h0011;
  tb.b = 32'h0101;
  tb.aluop = ALU_SLT;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == ($signed(tb.a) < $signed(tb.b)))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //13, SLTU////////////////////////////////////////////////////////////////////////////
  tb_test_case = "SLTU";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h1;
  tb.b = 32'h01;
  tb.aluop = ALU_SLTU;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.out == (tb.a < tb.b))) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //14, OVERFLOW ADD////////////////////////////////////////////////////////////////////////////
  tb_test_case = "OVERFLOW ADD";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h7fffffff;
  tb.b = 32'h7fffffff;
  tb.aluop = ALU_ADD;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.overflow == 1)) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //15, OVERFLOW SUB////////////////////////////////////////////////////////////////////////////
  tb_test_case = "OVERFLOW SUB";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h80000000;
  tb.b = 32'h7fffffff;
  tb.aluop = ALU_SUB;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.overflow == 1)) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //16, NEGATIVE////////////////////////////////////////////////////////////////////////////
  tb_test_case = "NEGATIVE";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'hffffffff;
  tb.b = 32'hffffffff;
  tb.aluop = ALU_ADD;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.negative == 1)) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //17, ZERO////////////////////////////////////////////////////////////////////////////
  tb_test_case = "ZERO";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.a = 32'h0;
  tb.b = 32'h0;
  tb.aluop = ALU_ADD;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.zero == 1)) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

end
endprogram
