onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hazard_unit_tb/CLK
add wave -noupdate /hazard_unit_tb/nRST
add wave -noupdate /hazard_unit_tb/PROG/tb_test_case
add wave -noupdate /hazard_unit_tb/PROG/tb_test_case_num
add wave -noupdate /hazard_unit_tb/huif/instr_in
add wave -noupdate /hazard_unit_tb/huif/flush
add wave -noupdate /hazard_unit_tb/huif/freeze
add wave -noupdate /hazard_unit_tb/huif/branch
add wave -noupdate /hazard_unit_tb/huif/bne
add wave -noupdate /hazard_unit_tb/huif/zero_flag
add wave -noupdate /hazard_unit_tb/huif/mem_regwrite
add wave -noupdate /hazard_unit_tb/huif/jump_sel
add wave -noupdate /hazard_unit_tb/huif/rs
add wave -noupdate /hazard_unit_tb/huif/rt
add wave -noupdate /hazard_unit_tb/huif/rw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {122 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {562 ns}
