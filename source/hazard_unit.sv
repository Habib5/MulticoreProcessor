
`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"
`include "f_d_if.vh"
import cpu_types_pkg::*; 

module hazard_unit 
(
  hazard_unit_if.hu huif
);

opcode_t opcode_dec, opcode_ex, opcode_mem;
assign opcode_dec = opcode_t'(huif.instr_dec[31:26]);
assign opcode_ex = opcode_t'(huif.instr_ex[31:26]);
assign opcode_mem = opcode_t'(huif.instr_mem[31:26]);

assign huif.freeze_dex = huif.freeze_fd;

always_comb begin
  huif.freeze_fd = 0;

  if (~huif.dhit && (opcode_ex == LW || opcode_ex == SW || opcode_ex == LL || opcode_ex == SC)) 
  //if (~huif.dhit && (opcode_ex == LW || opcode_ex == SW))
  begin
    if ((huif.rs_dec == huif.rw_memory) && huif.mem_regwrite)
      huif.freeze_fd = 1;
    else if ((huif.rt_dec == huif.rw_memory) && huif.mem_regwrite)
      huif.freeze_fd = 1;
  end

end

//flush logic
always_comb begin
  huif.flush = 0;

  if (huif.jump_sel == 2'b11 && ((huif.bne && ~huif.zero_flag) || (~huif.bne && huif.zero_flag))) 
    begin
      huif.flush = 1;
    end
  else if (huif.jump_sel == 2'b01 || huif.jump_sel == 2'b10) begin
      huif.flush = 1;
    end
  else
      huif.flush = 0;
  end

endmodule
