onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DSP_TB/CLK
add wave -noupdate /DSP_TB/OPMODE
add wave -noupdate -divider inputs
add wave -noupdate /DSP_TB/PCIN
add wave -noupdate /DSP_TB/BCIN
add wave -noupdate /DSP_TB/A
add wave -noupdate /DSP_TB/B
add wave -noupdate /DSP_TB/D
add wave -noupdate /DSP_TB/C
add wave -noupdate /DSP_TB/CARRYIN
add wave -noupdate -divider outputs
add wave -noupdate /DSP_TB/BCOUT
add wave -noupdate /DSP_TB/M
add wave -noupdate /DSP_TB/PCOUT
add wave -noupdate /DSP_TB/P
add wave -noupdate /DSP_TB/CARRYOUT
add wave -noupdate /DSP_TB/CARRYOUTF
add wave -noupdate -divider resets
add wave -noupdate /DSP_TB/RSTA
add wave -noupdate /DSP_TB/RSTB
add wave -noupdate /DSP_TB/RSTC
add wave -noupdate /DSP_TB/RSTCARRYIN
add wave -noupdate /DSP_TB/RSTD
add wave -noupdate /DSP_TB/RSTM
add wave -noupdate /DSP_TB/RSTOPMODE
add wave -noupdate /DSP_TB/RSTP
add wave -noupdate -divider enables
add wave -noupdate /DSP_TB/CEA
add wave -noupdate /DSP_TB/CEB
add wave -noupdate /DSP_TB/CEC
add wave -noupdate /DSP_TB/CECARRYIN
add wave -noupdate /DSP_TB/CED
add wave -noupdate /DSP_TB/CEM
add wave -noupdate /DSP_TB/CEOPMODE
add wave -noupdate /DSP_TB/CEP
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18 ns} 0}
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
WaveRestoreZoom {0 ns} {37 ns}
