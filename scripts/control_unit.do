onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/cuif/instr
add wave -noupdate /control_unit_tb/cuif/aluop
add wave -noupdate /control_unit_tb/cuif/rs
add wave -noupdate /control_unit_tb/cuif/rt
add wave -noupdate /control_unit_tb/cuif/rd
add wave -noupdate /control_unit_tb/cuif/imm
add wave -noupdate /control_unit_tb/cuif/ALUSrc
add wave -noupdate /control_unit_tb/cuif/regDest
add wave -noupdate /control_unit_tb/cuif/jumpAddr
add wave -noupdate /control_unit_tb/cuif/PCSrc
add wave -noupdate /control_unit_tb/cuif/regWrite
add wave -noupdate /control_unit_tb/cuif/imemREN
add wave -noupdate /control_unit_tb/cuif/dREN
add wave -noupdate /control_unit_tb/cuif/dWEN
add wave -noupdate /control_unit_tb/cuif/J
add wave -noupdate /control_unit_tb/cuif/JAL
add wave -noupdate /control_unit_tb/cuif/memToReg
add wave -noupdate /control_unit_tb/cuif/extOp
add wave -noupdate /control_unit_tb/cuif/funct
add wave -noupdate /control_unit_tb/cuif/shamt
add wave -noupdate /control_unit_tb/cuif/halt
add wave -noupdate /control_unit_tb/cuif/LUI
add wave -noupdate /control_unit_tb/cuif/BNE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66 ns} 0}
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
WaveRestoreZoom {0 ns} {310 ns}
