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

* `**datapath.v**`: The top-level module integrating all components and implementing the 4-stage pipeline registers. It manages the flow of data and control signals through the pipeline.
* `**alu.v**`: Implements the Arithmetic Logic Unit, performing operations like addition, subtraction, AND, OR, XOR, and NOT on 16-bit operands based on a 4-bit select signal.
* `**register_file.v**`: Models a 32x16-bit register file, allowing simultaneous reads from two registers and synchronous writes to one.
* `**memory.v**`: Represents a simple 256x16-bit data memory, supporting synchronous write and combinational read operations.
* `**clk2phase.v**`: Generates two non-overlapping clock phases (`phi1`, `phi2`) from a single input clock, essential for controlling pipeline stage transitions.
* `**datapath_tb.v**`: The testbench module responsible for generating the main clock, reset signal, and providing stimulus (instruction parameters) to the `datapath` for behavioral simulation and verification.
