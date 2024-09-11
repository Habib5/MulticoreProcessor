`include "request_unit_if.vh"
`timescale 1 ns / 1 ns

module request_unit_tb;
    parameter PERIOD = 10;
    logic CLK = 0, nRST;
    // clock
    always #(PERIOD/2) CLK++;

    request_unit_if ruif ();
    test PROG (CLK, nRST);

    //DUT
`ifndef MAPPED
  request_unit DUT(CLK, nRST, ruif);
`else
  request_unit DUT(
    .\ruif.ihit (ruif.ihit),
    .\ruif.dhit (ruif.dhit),
    .\ruif.dWEN (ruif.dWEN),
    .\ruif.dREN (ruif.dREN),
    .\ruif.dmemREN (ruif.dmemREN),
    .\ruif.dmemWEN (ruif.dmemWEN),
    .\ruif.pcen (ruif.pcen),

    .\nRST (nRST),
    .\CLK (CLK)
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

//turn all signals on and off

initial
begin
    reset_DUT();

    ruif.dhit = 0;
    ruif.ihit = 0;
    ruif.dWEN = 0;
    ruif.dREN = 0;

    @(posedge CLK);
    @(posedge CLK);

    ruif.dhit = 1;

    @(posedge CLK);
    @(posedge CLK);

    ruif.dhit = 0;

    @(posedge CLK)
    @(posedge CLK)

    ruif.ihit = 1;

    @(posedge CLK);
    @(posedge CLK);

    ruif.ihit = 0;

    @(posedge CLK)
    @(posedge CLK)

     ruif.dWEN = 1;

    @(posedge CLK);
    @(posedge CLK);

    ruif.dWEN = 0;

    @(posedge CLK)
    @(posedge CLK)

    ruif.dREN = 1;

    @(posedge CLK);
    @(posedge CLK);

    ruif.dREN = 0;

    @(posedge CLK)
    @(posedge CLK)

    $finish;
end

endprogram