# 4-Bit Processor using Verilog HDL

## Overview
This project implements a **4-Bit Processor** using **Verilog HDL** to demonstrate the fundamentals of processor architecture and digital system design. The processor executes a basic instruction set and integrates essential components such as the ALU, register file, program counter, instruction decoder, and control unit. This project is intended for students and beginners learning computer architecture, digital electronics, and FPGA design.

---

## Features
- 4-bit data path architecture
- Arithmetic Logic Unit (ALU)
- Register File
- Program Counter (PC)
- Instruction Decoder
- Control Unit
- Memory Interface
- Clock and Reset support
- Supports arithmetic and logical operations
- Supports data transfer instructions
- Supports branching instructions
- Modular Verilog design
- Easy to simulate and understand

---

## Processor Components

### Arithmetic Logic Unit (ALU)
Performs arithmetic and logical operations including:
- Addition
- Subtraction
- AND
- OR
- XOR
- NOT

### Register File
Stores temporary data used during instruction execution.

### Program Counter (PC)
Maintains the address of the next instruction to be executed.

### Instruction Decoder
Decodes the fetched instruction and generates appropriate control signals.

### Control Unit
Controls the execution of instructions by coordinating all processor components.

---

## Supported Instructions

### Arithmetic Operations
- ADD
- SUB

### Logical Operations
- AND
- OR
- XOR
- NOT

### Data Transfer Operations
- MOV
- LOAD
- STORE

### Branch Operations
- Conditional Branch
- Unconditional Branch

---

## Folder Structure

```
4-Bit-Processor/
│── src/
│   ├── alu.v
│   ├── register_file.v
│   ├── control_unit.v
│   ├── instruction_decoder.v
│   ├── program_counter.v
│   └── processor_top.v
│
│── testbench/
│   └── processor_tb.v
│
│── README.md
```

*(Modify the folder names according to your project.)*

---

## Tools Used

- Verilog HDL
- ModelSim
- Xilinx Vivado
- FPGA Development Tools

---

## Simulation

The design can be simulated using:
- ModelSim
- Vivado Simulator

Compile all Verilog files and run the provided testbench to verify the processor functionality.

---

## Applications

- Processor Architecture Learning
- Digital Electronics
- Computer Organization
- FPGA Projects
- Academic Mini Projects
- Verilog HDL Practice

---

## Learning Outcomes

After completing this project, you will understand:

- Processor Architecture
- Instruction Execution Cycle
- Register Transfer Operations
- ALU Design
- Control Unit Design
- Program Counter Operation
- Instruction Decoding
- Verilog HDL Coding
- RTL Simulation

---

## Future Enhancements

- Increase processor width to 8-bit or 16-bit
- Pipeline implementation
- Interrupt handling
- Cache memory support
- UART communication
- FPGA hardware implementation

---

## Author

**Raja Nayak**

Electronics and Communication Engineering (ECE)

Interested in Digital Design, FPGA, VLSI, and Embedded Systems.

---
