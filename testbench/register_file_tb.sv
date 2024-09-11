/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test (
    input logic CLK,
    output logic nRST,
    register_file_if.tb tb
);

task reset_DUT();
  @(negedge CLK);

  nRST = 1'b0;

  @(posedge CLK);
  @(posedge CLK);

  nRST = 1'b1;

  @(posedge CLK);
  @(posedge CLK);

  @(negedge CLK);
endtask

string tb_test_case;
int tb_test_case_num;

initial begin

  tb.wdat = '0;
  tb.rsel1 = '0;
  tb.rsel2 = '0;
  tb.wsel = '0;
  tb.WEN = '0;
  nRST = 1;
  reset_DUT();
  
  @(posedge CLK);
  @(posedge CLK);

  tb_test_case = "Initial";
  tb_test_case_num = -1;

  //1
  //async reset
  //read everything
  tb_test_case = "Async Reset";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.WEN = 1'b1;
  tb.wsel = 5'd4;
  tb.wdat = 32'h4545;
  tb.rsel1 = 5'd4;
  tb.rsel2 = 5'd5;

  @(posedge CLK);
  @(posedge CLK);

  tb.WEN = 1'b0;
  reset_DUT();

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.rdat1 == 32'h0000) && (tb.rdat2 == 32'h0000)) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  //2
  //write to 0
  //read 0 and check if 0
  tb_test_case = "Write to 0";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.WEN = 1'b1;
  tb.wsel = 5'd0;
  tb.wdat = 32'h2323;

  @(posedge CLK);
  @(posedge CLK);

  tb.rsel1 = 5'd0;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.rdat1 == 32'h0000)) 
    $display("Test case %s successful", tb_test_case);
  else 
    $display("not successful on test %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);


  //3
  //write to every reg
  //read every reg
  //make sure same
  tb_test_case = "Write and Read";
  tb_test_case_num = tb_test_case_num + 1;
  reset_DUT();
  @(negedge CLK);

  tb.WEN = 1'b1;
  tb.wsel = 5'd9;
  tb.wdat = 32'h1212;
  tb.rsel1 = 5'd12;
  tb.rsel2 = 5'd9;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.rdat2 == 32'h1212)) 
    $display("Test case 1 of %s successful", tb_test_case);
  else 
    $display("not successful on test 1 of %s", tb_test_case);

  @(posedge CLK);
  @(posedge CLK);

  tb.wsel = 5'd12;

  @(posedge CLK);
  @(posedge CLK);

  assert((tb.rdat1 == 32'h1212)) 
    $display("Test case 2 of %s successful", tb_test_case);
  else 
    $display("not successful on test 2 of %s", tb_test_case);
end



endprogram
