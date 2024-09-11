`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1 ns

module hazard_unit_tb;
    parameter PERIOD = 10;
    logic CLK = 0, nRST;
    // clock
    always #(PERIOD/2) CLK++;

    hazard_unit_if huif ();
    test PROG (CLK, nRST, huif);

    //DUT
`ifndef MAPPED
  hazard_unit DUT(huif);
`else
  hazard_unit DUT(
.\huif.instr_in (huif.instr_in),
.\huif.jump_sel (huif.jump_sel),
.\huif.branch (huif.branch),
.\huif.zero_flag (huif.zero_flag),
.\huif.bne (huif.bne),
.\huif.freeze (huif.freeze),
.\huif.flush (huif.flush),
.\nRST (nRST),
.\CLK (CLK)
  );
`endif
endmodule

program test(
    input logic CLK,
    output logic nRST,
    hazard_unit_if.tb tb
);

task reset_DUT();
  @(negedge CLK);
  nRST = 1'b0;

  @(posedge CLK);

  nRST = 1'b1;

  @(posedge CLK);
  @(negedge CLK);
endtask

string tb_test_case;
int tb_test_case_num;

initial
begin
    //initialization
    tb.instr_in = '0; 
    tb.jump_sel = '0; 
    tb.branch = '0; 
    tb.zero_flag = '0; 
    tb.bne = '0;
    nRST = 1;
    reset_DUT();

    @(posedge CLK);
    @(posedge CLK);

    tb_test_case = "Initial";
    tb_test_case_num = -1;

    //1
    //jump_sel = 2'b00, pc/npc 
    tb_test_case = "No jump, No branch";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    tb.instr_in = '0; 
    tb.jump_sel = '0; 
    tb.branch = '0; 
    tb.zero_flag = '0; 
    tb.bne = '0;

    @(posedge CLK);
    @(posedge CLK);

    assert((tb.flush == 0) && (tb.freeze == 0)) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s", tb_test_case);

    @(posedge CLK);
    @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //2
    //jump_sel = 2'b01, J/JAL 
    tb_test_case = "J/JAL";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    tb.instr_in = '0; 
    tb.jump_sel = 2'b01; 
    tb.branch = '0; 
    tb.zero_flag = '0; 
    tb.bne = '0;

    @(posedge CLK);
    @(posedge CLK);

    assert((tb.flush == 1) && (tb.freeze == 0)) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s", tb_test_case);

    @(posedge CLK);
    @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //3
    //jump_sel = 2'b10, JR 
    tb_test_case = "JR";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    tb.instr_in = '0; 
    tb.jump_sel = 2'b10; 
    tb.branch = '0; 
    tb.zero_flag = '0; 
    tb.bne = '0;

    @(posedge CLK);
    @(posedge CLK);

    assert((tb.flush == 1) && (tb.freeze == 0)) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s", tb_test_case);

    @(posedge CLK);
    @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //4
    //jump_sel = 2'b11, Branch BEQ
    tb_test_case = "Branch, BEQ";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    tb.instr_in = '0; 
    tb.jump_sel = 2'b11; 
    tb.branch = 1; 
    tb.zero_flag = 1; 
    tb.bne = '0;

    @(posedge CLK);
    @(posedge CLK);

    assert((tb.flush == 1) && (tb.freeze == 0)) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s", tb_test_case);

    @(posedge CLK);
    @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //5
    //jump_sel = 2'b11, Branch BNE
    tb_test_case = "Branch, BNE";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    tb.instr_in = '0; 
    tb.jump_sel = 2'b11; 
    tb.branch = 1; 
    tb.zero_flag = '0; 
    tb.bne = '1;

    @(posedge CLK);
    @(posedge CLK);

    assert((tb.flush == 1) && (tb.freeze == 0)) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s", tb_test_case);

    @(posedge CLK);
    @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //6
    //SW
    // tb_test_case = "SW";
    // tb_test_case_num = tb_test_case_num + 1;
    // reset_DUT();
    // @(negedge CLK);

    // tb.instr_in[31:26] = SW; 
    // tb.jump_sel = '0; 
    // tb.branch = '0; 
    // tb.zero_flag = '0; 
    // tb.bne = '0;

    // @(posedge CLK);
    // @(posedge CLK);

    // assert((tb.flush == 0) && (tb.freeze == 1)) 
    //     $display("Test case %s successful", tb_test_case);
    // else 
    //     $display("not successful on test %s", tb_test_case);

    // @(posedge CLK);
    // @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //7
    //LW
    // tb_test_case = "LW";
    // tb_test_case_num = tb_test_case_num + 1;
    // reset_DUT();
    // @(negedge CLK);

    // tb.instr_in[31:26] = LW; 
    // tb.jump_sel = '0; 
    // tb.branch = '0; 
    // tb.zero_flag = '0; 
    // tb.bne = '0;

    // @(posedge CLK);
    // @(posedge CLK);

    // assert((tb.flush == 0) && (tb.freeze == 1)) 
    //     $display("Test case %s successful", tb_test_case);
    // else 
    //     $display("not successful on test %s", tb_test_case);

    // @(posedge CLK);
    // @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    $finish;
end
endprogram