// `include "forwarding_unit_if.vh"
// `include "cpu_types_pkg.vh"
// import cpu_types_pkg::*;
// `timescale 1 ns / 1 ns

// module forwarding_unit_tb;
//     parameter PERIOD = 10;
//     logic CLK = 0, nRST;
//     // clock
//     always #(PERIOD/2) CLK++;

//     forwarding_unit_if fuif ();
//     test PROG (CLK, nRST, fuif);

//     //DUT
// `ifndef MAPPED
//   forwarding_unit DUT(fuif);
// `else
//   hazard_unit DUT(
// .\fuif.rs (fuif.rs),
// .\fuif.rt (fuif.rt),
// .\fuif.rw_mem (fuif.rw_mem),
// .\fuif.rw_wb (fuif.rw_wb),
// .\fuif.rw_mem_reg (fuif.rw_mem_reg),
// .\fuif.rw_wb_reg (fuif.rw_wb_reg),
// .\fuif.data_mem (fuif.data_mem),
// .\fuif.data_wb (fuif.data_wb),
// .\fuif.rs_new (fuif.rs_new),
// .\fuif.rt_new (fuif.rt_new),
// .\fuif.rdat1_f (fuif.rdat1_f),
// .\fuif.rdat2_f (fuif.rdat2_f),
// .\nRST (nRST),
// .\CLK (CLK)
//   );
// `endif
// endmodule

// program test(
//     input logic CLK,
//     output logic nRST,
//     forwarding_unit_if.tb tb
// );

// task reset_DUT();
//   @(negedge CLK);
//   nRST = 1'b0;

//   @(posedge CLK);

//   nRST = 1'b1;

//   @(posedge CLK);
//   @(negedge CLK);
// endtask

// string tb_test_case;
// int tb_test_case_num;

// initial
// begin
//     //test all collisions
//     //initialization
//     tb.rs = '0; 
//     tb.rt = '0; 
//     tb.rw_mem = '0; 
//     tb.rw_wb = '0; 
//     tb.rw_mem_reg = '0;
//     tb.rw_wb_reg = '0;
//     tb.data_mem = '0;
//     tb.data_wb = '0;

//     nRST = 1;
//     reset_DUT();

//     @(posedge CLK);
//     @(posedge CLK);

//     tb_test_case = "Initial";
//     tb_test_case_num = -1;

//     //1
//     //rs = rw_mem
//     tb_test_case = "rs = rw_mem";
//     tb_test_case_num = tb_test_case_num + 1;
//     reset_DUT();
//     @(negedge CLK);

//     tb.rs = 5'b00010; 
//     tb.rt = '0; 
//     tb.rw_mem = 1; 
//     tb.rw_wb = '0; 
//     tb.rw_mem_reg = 5'b00010;
//     tb.rw_wb_reg = '0;
//     tb.data_mem = 32'h03030303;
//     tb.data_wb = '0;

//     @(posedge CLK);
//     @(posedge CLK);

//     assert((tb.rdat1_f == 1) && (tb.rs_new == 32'h03030303)) 
//         $display("Test case %s successful", tb_test_case);
//     else 
//         $display("not successful on test %s", tb_test_case);

//     @(posedge CLK);
//     @(posedge CLK);

// //////////////////////////////////////////////////////////////////////////////////

//     //2
//     //rs = rw_wb
//     tb_test_case = "rs = rw_wb";
//     tb_test_case_num = tb_test_case_num + 1;
//     reset_DUT();
//     @(negedge CLK);

//     tb.rs = 5'b00011; 
//     tb.rt = '0; 
//     tb.rw_mem = '0; 
//     tb.rw_wb = 1; 
//     tb.rw_mem_reg = '0;
//     tb.rw_wb_reg = 5'b00011;
//     tb.data_mem = '0;
//     tb.data_wb = 32'h04040404;

//     @(posedge CLK);
//     @(posedge CLK);

//     assert((tb.rdat1_f == 1) && (tb.rs_new == 32'h04040404)) 
//         $display("Test case %s successful", tb_test_case);
//     else 
//         $display("not successful on test %s", tb_test_case);

//     @(posedge CLK);
//     @(posedge CLK);

// //////////////////////////////////////////////////////////////////////////////////

//     //3
//     //rt = rw_mem
//     tb_test_case = "rt = rw_mem";
//     tb_test_case_num = tb_test_case_num + 1;
//     reset_DUT();
//     @(negedge CLK);

//     tb.rs = '0; 
//     tb.rt = 5'b00110; 
//     tb.rw_mem = 1; 
//     tb.rw_wb = '0; 
//     tb.rw_mem_reg = 5'b00110;
//     tb.rw_wb_reg = '0;
//     tb.data_mem = 32'h05050505;
//     tb.data_wb = '0;

//     @(posedge CLK);
//     @(posedge CLK);

//     assert((tb.rdat2_f == 1) && (tb.rt_new == 32'h05050505)) 
//         $display("Test case %s successful", tb_test_case);
//     else 
//         $display("not successful on test %s", tb_test_case);

//     @(posedge CLK);
//     @(posedge CLK);

// //////////////////////////////////////////////////////////////////////

//     //4
//     //rt = rw_wb
//     tb_test_case = "rt = rw_wb";
//     tb_test_case_num = tb_test_case_num + 1;
//     reset_DUT();
//     @(negedge CLK);

//     tb.rs = '0; 
//     tb.rt = 5'b00111; 
//     tb.rw_mem = '0; 
//     tb.rw_wb = 1; 
//     tb.rw_mem_reg = '0;
//     tb.rw_wb_reg = 5'b00111;
//     tb.data_mem = '0;
//     tb.data_wb = 32'h00000022;

//     @(posedge CLK);
//     @(posedge CLK);

//     assert((tb.rdat2_f == 1) && (tb.rt_new == 32'h00000022)) 
//         $display("Test case %s successful", tb_test_case);
//     else 
//         $display("not successful on test %s", tb_test_case);

//     @(posedge CLK);
//     @(posedge CLK);

// //////////////////////////////////////////////////////////////////////////////////

//     $finish;
// end
// endprogram