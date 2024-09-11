onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate -color Gold /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider RAM
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -divider DATAPATH
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP0/pc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP0/next_pc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP0/npc
add wave -noupdate -divider Cache
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -divider Latches
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/instr_out
add wave -noupdate /system_tb/DUT/CPU/DP0/dexif/instr_out
add wave -noupdate /system_tb/DUT/CPU/DP0/exmif/instr_out
add wave -noupdate /system_tb/DUT/CPU/DP0/mwbif/instr_out
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/CLK
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/nRST
add wave -noupdate -expand -group DCACHE -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/ht[5]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/ht
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/i
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/offset
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/tag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/ind
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/row_trunc
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/miss
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/available
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_available
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/row
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_row
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/hit_count
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_hit_count
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_state
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/linkreg
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_linkreg
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/linkreg_valid
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_linkreg_valid
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/left_tag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/right_tag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/left_data1
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/left_data2
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/right_data1
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/right_data2
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/left_dirty
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/left_valid
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/right_dirty
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/right_valid
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sleft_tag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sright_tag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sleft_data1
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sleft_data2
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sright_data1
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sright_data2
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sleft_dirty
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sleft_valid
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sright_dirty
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/sright_valid
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/snooptag
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/snoopind
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/snoopoffset
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/snoophitL
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/snoophitR
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/snoopdirty
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_snoophitL
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/next_snoophitR
add wave -noupdate -expand -group DCACHE /system_tb/DUT/CPU/CM0/DCACHE/j
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /system_tb/CLK
add wave -noupdate -color Gold /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider RAM
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -divider DATAPATH
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -expand -group Datapath2 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -divider ALU
add wave -noupdate -divider {Register File}
add wave -noupdate -divider {request unit}
add wave -noupdate -divider {control unit}
add wave -noupdate -divider {Hazard Unit}
add wave -noupdate -divider {Forwarding Unit}
add wave -noupdate -divider PC
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP1/pc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP1/next_pc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP1/npc
add wave -noupdate -divider Cache
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group Cache /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -divider Latches
add wave -noupdate /system_tb/DUT/CPU/DP1/fdif/instr_out
add wave -noupdate /system_tb/DUT/CPU/DP1/dexif/instr_out
add wave -noupdate /system_tb/DUT/CPU/DP1/mwbif/instr_out
add wave -noupdate /system_tb/DUT/CPU/DP1/exmif/instr_out
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group {Bus Signals} /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/iwait
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/dwait
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/iREN
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/dREN
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/dWEN
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/iload
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/dload
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/dstore
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/iaddr
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/daddr
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/ccwait
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/ccinv
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/ccwrite
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/cctrans
add wave -noupdate -expand -group {Pro 1 Bus Control} /system_tb/DUT/CPU/ccif/cif0/ccsnoopaddr
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/iwait
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/dwait
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/iREN
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/dREN
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/dWEN
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/iload
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/dload
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/dstore
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/iaddr
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/daddr
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/ccwait
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/ccinv
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/ccwrite
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/cctrans
add wave -noupdate -group {Pro 2 Bus Control} /system_tb/DUT/CPU/ccif/cif1/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/CC/state
add wave -noupdate /system_tb/DUT/CPU/CC/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13877365977 ps} 0} {{Cursor 2} {1049533 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {826 ns} {1441 ns}
