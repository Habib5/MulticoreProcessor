`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  //ihit and dhit correspond to the ready signals

  logic     ihit, dhit, dWEN, dREN, dmemREN, dmemWEN, pcen;

  // request unit ports
  modport ru (
    input   ihit, dhit, dWEN, dREN,
    output  dmemREN, dmemWEN, pcen
  );
  // request unit tb
  modport tb (
    output   ihit, dhit, dWEN, dREN,
    input  dmemREN, dmemWEN, pcen
  );
endinterface

`endif //REQUEST_UNIT_IF_VH