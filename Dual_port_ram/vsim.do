vlib work

# Xóa file log cũ
vdel -all

# Compile tất cả các file SystemVerilog/Verilog
vlog -sv ram_dp_async_read.v tb_ram_dp_async_read.v

# Load testbench trong chế độ UVM
vsim -uvmcontrol=all work.tb_ram_dp_async_read



# Thêm tất cả tín hiệu vào waveform
#add wave -r /*

# Chạy mô phỏng
run -all
