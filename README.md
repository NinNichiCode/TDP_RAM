# True Dual Port RAM Design (Verilog)

This project implements a **True Dual Port RAM** module in Verilog, allowing **simultaneous read and write operations on both ports (Port A and Port B)**.

## Overview
True Dual Port RAM is commonly used in digital systems that require parallel data access. Unlike single-port RAM, this design enables **independent read/write operations on two separate ports**, increasing data throughput and system performance.

##  Features
- **Data Width**: 8 bits  
- **Address Depth**: 64 entries  
- **Simultaneous access**: Read/Write support on both ports independently
- **Bypass mechanism**: Enables immediate data visibility after write, without waiting for the next read cycle (optional)


##  Verification
A testbench is included to verify the RAM's functionality:
- Write/read operations on both ports
- Read-after-write bypass behavior
- Simultaneous access with different or the same addresses

##  Tools Used
- Verilog HDL
- QuestaSim for simulation

##  Files
- `true_dual_port_ram.v`: Verilog implementation
- `tb_true_dual_port_ram.v`: Testbench for functional verification
- `vsim.do`: Simulation automation script 

## How to Run
1. Open your simulator
2. Compile the design and testbench files then simulate
Or you can run the compile and simulate using `vsim.do`.
 Observe waveform or console output for verification results.




