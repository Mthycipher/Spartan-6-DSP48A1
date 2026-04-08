vlib project1
vmap work project1

vlog ../Code/ADD_SUB.v
vlog ../Code/regs_mux.v
vlog ../Code/DSP.v
vlog ../Code/DSP_TB.v

vsim -voptargs=+acc project1.DSP_TB

do wave.do

run -all