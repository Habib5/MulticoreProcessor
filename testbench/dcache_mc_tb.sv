`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module dcache_mc_tb;

 parameter PERIOD = 10;
 logic CLK = 0, nRST;

 always #(PERIOD/2) CLK++;

 // interface delcaration
 caches_if cif ();
 datapath_cache_if dcif ();
 // test program setup
 test PROG (CLK, nRST, dcif, cif);

`ifndef MAPPED
 dcache DUT(CLK, nRST, dcif, cif);

`else
 dcache DUT(
 .\dcif.halt(dcif.halt),
 .\dcif.dmemREN(dcif.dmemREN),
 .\dcif.dmemWEN(dcif.dmemWEN),
 .\dcif.datomic(dcif.datomic),
 .\dcif.dmemstore(dcif.dmemstore),
 .\dcif.dmemaddr(dcif.dmemaddr),
 .\dcif.imemaddr(dcif.imemaddr),
 .\dcif.imemREN(dcif.imemREN),
 .\cif.dwait(cif.dwait),
 .\cif.dload(cif.dload),
 .\cif.iwait(cif.iwait),
 .\cif.iload(cif.iload),
 .\cif.ccwait(cif.ccwait),
 .\cif.ccinv(cif.ccinv),
 .\cif.ccsnoopaddr(cif.ccsnoopaddr),
 .\CLK(CLK),
 .\nRST(nRST),
 );
`endif

endmodule

program test(
    input logic CLK,
    output logic nRST,
    datapath_cache_if.cache dcif,
    caches_if.caches cif
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

initial begin
    dcif.halt = 0; 
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 0;
    dcif.imemaddr = 0;
    dcif.imemREN = 1;

    cif.dwait = 1;
    cif.dload = 0;
    cif.iwait = 1;
    cif.iload = 0;
    cif.ccwait = 0;
    cif.ccinv = 0;
    cif.ccsnoopaddr = 0;
 
    nRST = 1;
    reset_DUT();

    @(posedge CLK);
    @(posedge CLK);

    tb_test_case = "Initial";
    tb_test_case_num = -1;
 
    //1
    //index 5 tag match
    tb_test_case = "index 5 tag match";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    //miss on 5
    dcif.dmemaddr = {26'b00000000000000000000000001, 3'b101, 1'b0, 2'b00};

    repeat (10)
        @(posedge CLK);

    cif.dload = 32'h11223344;
    cif.dwait = 0;

    repeat (10)
        @(posedge CLK);

    //reading from 5
    dcif.dmemaddr = {26'b00000000000000000000000001, 3'b101, 1'b0, 2'b00};
    cif.dload = '0;
    cif.dwait = 1;
    dcif.dmemREN = 1;
    @(negedge CLK);


    assert((dcif.dhit == 1) && (dcif.dmemload == 32'h11223344) && (cif.dREN == 0)) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s at time %0t", tb_test_case, $time);

    @(posedge CLK);
    @(posedge CLK);

    //////////////////////////////////////////////////////////////////////////////////

    //2
    //index 2 tag mismatch
    tb_test_case = "index 2 tag mismatch";
    tb_test_case_num = tb_test_case_num + 1;
    reset_DUT();
    @(negedge CLK);

    //writing to 2
    dcif.dmemaddr = {26'b00000000000000000000001111, 3'b010, 1'b0, 2'b0};

    repeat (10)
        @(posedge CLK);

    cif.dload = 32'h55667788;
    cif.dwait = 0;

    repeat (10)
        @(posedge CLK);

    //reading from 2
    dcif.dmemaddr = {26'b00000000000000000000000001, 3'b010, 1'b0, 2'b0};
    cif.dload = 32'hDEEEDEEE;
    cif.dwait = 0;
    dcif.dmemREN = 1;
    @(posedge CLK);
    @(negedge CLK);

    assert((dcif.dhit == 0) && (cif.dREN == 1) && (cif.daddr == {26'b00000000000000000000000001, 4'b0010, 2'b00})) 
        $display("Test case %s successful", tb_test_case);
    else 
        $display("not successful on test %s at time %0t", tb_test_case, $time);

    @(posedge CLK);
    @(posedge CLK);

//////////////////////////////////////////////////////////////////////////////////

    //3 
    //add test cases that highlight sharing
    
    $finish;
 
end





endprogram