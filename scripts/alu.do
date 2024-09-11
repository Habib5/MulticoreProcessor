onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/PROG/tb_test_case
add wave -noupdate /alu_tb/PROG/tb_test_case_num
add wave -noupdate /alu_tb/CLK
add wave -noupdate /alu_tb/nRST
add wave -noupdate /alu_tb/rfif/negative
add wave -noupdate /alu_tb/rfif/overflow
add wave -noupdate /alu_tb/rfif/zero
add wave -noupdate -radix decimal /alu_tb/rfif/a
add wave -noupdate -radix decimal /alu_tb/rfif/b
add wave -noupdate -radix decimal /alu_tb/rfif/out
add wave -noupdate /alu_tb/rfif/aluop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {871 ns} 0}
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
WaveRestoreZoom {673 ns} {1412 ns}
