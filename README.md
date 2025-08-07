# 4-stage-Pipelined-Data-Path
This repository contains the Verilog implementation and testbench for a fundamental 4-stage pipelined datapath, designed to demonstrate the core principles of CPU architecture and pipelining.

---

### Overview

This project implements a simplified CPU datapath with the following 4-stage pipeline:

* **IF/RF** (Instruction Fetch / Register File access)
* **EX** (Execute)
* **MEM** (Memory Access)
* **WB** (Write Back)

The datapath processes a sequence of operations including arithmetic, logic, and memory load/store instructions. It demonstrates how these instructions move through the pipeline stages concurrently. A 2-phase clocking scheme is used to ensure robust inter-stage data transfer.

---

### Features

* **4-Stage Pipeline:** Demonstrates concurrent instruction execution.
* **Modular Design:** Functionality is separated into dedicated Verilog modules (ALU, Register File, Memory, Clock Generator).
* **2-Phase Clock:** Utilizes a non-overlapping two-phase clocking scheme to ensure correct stage isolation and prevent race conditions.
* **Debug Outputs:** Includes signals to observe internal pipeline states for verification.

---

### Architecture & Modules

The datapath is structured around the four pipeline stages, with pipeline registers between each stage to hold intermediate results and control signals.

* **datapath.v:** The top-level module that integrates all components and implements the pipeline registers. It manages the flow of data and control signals.
* **alu.v:** Implements the **Arithmetic Logic Unit**, performing operations like addition, subtraction, AND, OR, XOR, and NOT on 16-bit operands.
* **register_file.v:** Models a **32x16-bit register file**, allowing simultaneous reads from two registers and synchronous writes to one.
* **memory.v:** Represents a simple **256x16-bit data memory**, supporting synchronous writes and combinational reads.
* **clk2phase.v:** Generates two non-overlapping clock phases (`phi1`, `phi2`) from a single input clock, essential for controlling pipeline transitions.
* **datapath_tb.v:** The **testbench** module responsible for generating the main clock, reset signal, and providing stimulus for behavioral simulation and verification.

---

### Repository Structure

```text
.
├── datapath.v
├── alu.v
├── register_file.v
├── memory.v
├── clk2phase.v
├── datapath_tb.v
└── README.md
```
---

## Supported Features

* The basic **Read** and **Write** operation for Data storage and Retrieval.

* The ALU supports the following 16 operations, selected by the `sel` input:

| `sel`       | Operation       | Description                                  |                          
| :---------- | :-------------- | :------------------------------------------- |
| `4'h0`      | `ADD`           | Addition                                     |                   
| `4'h1`      | `SUB`           | Subtraction                                  |                     
| `4'h2`      | `MUL`           | Multiplication                               |                
| `4'h3`      | `DIV`           | Division (Integer)                           |
| `4'h4`      | `SRA`           | Logical Right Shift of A by 1 bit            |                    
| `4'h5`      | `SLA`           | Logical Left Shift of A by 1 bit             |                     
| `4'h6`      | `AND`           | Bitwise AND                                  |
| `4'h7`      | `OR`            | Bitwise OR                                   |
| `4'h8`      | `XOR`           | Bitwise XOR                                  |        
| `4'h9`      | `INV`           | Bitwise Inversion of A                       |                    
| `4'hA`      | `XNOR`          | Bitwise XNOR                                 |                        
| `4'hB`      | `NAND`          | Bitwise NAND                                 |                       
| `4'hC`      | `RRA`           | Right Rotate of A by 1 bit                   |                          
| `4'hD`      | `RLA`           | Left Rotate of A by 1 bit                    |
| `4'hE`      | `GT`            | Greater Than (A > B)                         |
| `4'hF`      | `EQ`            | Equal To (A == B)                            |

## Scope for Improvement
This datapath is only a part of the core processor model, a significant area for improvement would be the integration of an **ID (Instruction Decode) pipeline stage.**

Instruction Decode (ID) Stage: This stage would be responsible for:
* Decoding fetched instructions to understand the operation to be performed.
* Reading required operands from the Register File based on the decoded instruction.
* Generating control signals for subsequent EX, MEM, and WB stages based on the instruction type.

Incorporating an ID stage would complete the instruction processing pipeline, transitioning this datapath into a more functional and representative CPU core.
