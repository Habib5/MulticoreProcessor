onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dhit
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemREN
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemWEN
add wave -noupdate -expand -group dcif /dcache_tb/dcif/flushed
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemload
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemstore
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemaddr
add wave -noupdate -expand -group cif /dcache_tb/cif/dwait
add wave -noupdate -expand -group cif /dcache_tb/cif/dREN
add wave -noupdate -expand -group cif /dcache_tb/cif/dWEN
add wave -noupdate -expand -group cif /dcache_tb/cif/dload
add wave -noupdate -expand -group cif /dcache_tb/cif/dstore
add wave -noupdate -expand -group cif /dcache_tb/cif/daddr
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/ht
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/i
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/offset
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/tag
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/ind
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/row_trunc
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/miss
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/available
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/next_available
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/row
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/next_row
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/hit_count
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/next_hit_count
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/state
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/next_state
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/left_tag
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/right_tag
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/left_data1
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/left_data2
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/right_data1
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/right_data2
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/left_dirty
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/left_valid
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/right_dirty
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/right_valid
add wave -noupdate -expand -group {please save me} /dcache_tb/DUT/j
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7746 ns} 0}
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
WaveRestoreZoom {0 ns} {22901 ns}
