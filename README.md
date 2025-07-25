# 4-stage-Pipelined-Data-Path
This repository contains the Verilog HDL implementation and testbench for a fundamental 4-stage pipelined datapath, designed to demonstrate the core principles of CPU architecture and pipelining.

## Overview

This project implements a simplified CPU datapath featuring a 4-stage pipeline:
1.  **IF/RF (Instruction Fetch / Register File access)**
2.  **EX (Execute)**
3.  **MEM (Memory Access)**
4.  **WB (Write Back)**

It processes a sequence of operations including arithmetic, logic, and memory load/store operations, demonstrating how instructions move through different pipeline stages concurrently. A 2-phase clocking scheme is used for robust inter-stage data transfer.

## Features

* **4-Stage Pipeline:** Demonstrates concurrent instruction execution.
* **Modular Design:** Separates functionality into dedicated Verilog modules (ALU, Register File, Memory, Clock Generator).
* **2-Phase Clock:** Utilizes two-phase, non-overlapping clocking scheme to ensure correct **stage isolation and prevent race conditions**.
* **Debug Outputs:** Includes signals to observe internal pipeline states for verification.

## Architecture

The datapath is structured around the four pipeline stages, with pipeline registers between each stage to hold intermediate results and control signals.

## Module Breakdown

* `datapath.v`: The top-level module integrating all components and implementing the 4-stage pipeline registers. It manages the flow of data and control signals through the pipeline.
* `alu.v`: Implements the Arithmetic Logic Unit, performing operations like addition, subtraction, AND, OR, XOR, and NOT on 16-bit operands based on a 4-bit select signal.
* `register_file.v`: Models a 32x16-bit register file, allowing simultaneous reads from two registers and synchronous writes to one.
* `memory.v`: Represents a simple 256x16-bit data memory, supporting synchronous write and combinational read operations.
* `clk2phase.v`: Generates two non-overlapping clock phases (`phi1`, `phi2`) from a single input clock, essential for controlling pipeline stage transitions.
* `datapath_tb.v`: The testbench module responsible for generating the main clock, reset signal, and providing stimulus (instruction parameters) to the `datapath` for behavioral simulation and verification.

## Supported Features

* The basic **Read** and **Write** operation for Data storage and Retrieval.

* The ALU supports the following 16 operations, selected by the `sel` input:

| `sel`       | Operation       | Description                                  | Output                          |                           
| :---------- | :-------------- | :------------------------------------------- | :-------------------------------|
| `4'h0`      | `ADD`           | Addition                                     | `A + B`                         |                           
| `4'h1`      | `SUB`           | Subtraction                                  | `A - B`                         |                           
| `4'h2`      | `MUL`           | Multiplication                               | `A * B`                         |                           
| `4'h3`      | `DIV`           | Division (Integer)                           | `A / B`                         |                           
| `4'h4`      | `SRA`           | Logical Right Shift of A by 1 bit            | `A >> 1`                        |                          
| `4'h5`      | `SLA`           | Logical Left Shift of A by 1 bit             | `A << 1`                        |                           
| `4'h6`      | `AND`           | Bitwise AND                                  | `A & B`                         |                           
| `4'h7`      | `OR`            | Bitwise OR                                   | `A \| B`                        |                           
| `4'h8`      | `XOR`           | Bitwise XOR                                  | `A ^ B`                         |                           
| `4'h9`      | `INV`           | Bitwise Inversion of A                       | `~A`                            |                           
| `4'hA`      | `XNOR`          | Bitwise XNOR                                 | `~(A ^ B)`                      |                           
| `4'hB`      | `NAND`          | Bitwise NAND                                 | `~(A & B)`                      |                          
| `4'hC`      | `RRA`           | Right Rotate of A by 1 bit                   | `{A[0], A[7:1]}`                |                           
| `4'hD`      | `RLA`           | Left Rotate of A by 1 bit                    | `{A[6:0], A[7]}`                |
| `4'hE`      | `GT`            | Greater Than (A > B)                         | `16'd1` if A > B, else `16'd0`  |
| `4'hF`      | `EQ`            | Equal To (A == B)                            | `16'd1` if A == B, else `16'd0` |

## Scope for Improvement
This datapath is only a part of the core processor model, a significant area for improvement would be the integration of an **ID (Instruction Decode) pipeline stage.**

Instruction Decode (ID) Stage: This stage would be responsible for:
* Decoding fetched instructions to understand the operation to be performed.
* Reading required operands from the Register File based on the decoded instruction.
* Generating control signals for subsequent EX, MEM, and WB stages based on the instruction type.

Incorporating an ID stage would complete the instruction processing pipeline, transitioning this datapath into a more functional and representative CPU core.
