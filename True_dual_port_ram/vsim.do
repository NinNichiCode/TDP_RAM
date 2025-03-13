vlib work
vlog true_dual_port_ram.v tb_true_dual_port_ram.sv
vsim -voptargs=+acc tb_true_dual_port_ram
add wave sim:/tb_true_dual_port_ram/*
run -all
