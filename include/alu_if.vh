/*
  Habib Rahman
  brownxcash@gmail.com
  ALU interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     negative, overflow, zero;
  word_t    a, b, out;
  aluop_t   aluop;

  // register file ports
  modport rf (
    input   aluop, a, b,
    output  overflow, negative, zero, out
  );
  // register file tb
  modport tb (
    input   overflow, negative, zero, out,
    output  aluop, a, b
  );
endinterface

`endif //ALU_IF_VH