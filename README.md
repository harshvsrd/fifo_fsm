# fifo_fsm
Designed synchronous FIFO using Verilog RTL, featuring a 3-state FSM (EMPTY, PARTIAL, FULL) for FIFO status control. Implemented circular read/write pointers, memory-based data storage, full/empty handling, and simultaneous read/write operations. Developed a testbench to verify boundary conditions, pointer wrap-around, and FIFO data integrity.

# FIFO FSM — Verilog RTL

A synchronous **First-In First-Out (FIFO) buffer** designed and verified using Verilog RTL.

## Overview

This project implements an 8-entry FIFO using:

* 8-bit data width
* 3-bit circular read/write pointers
* 4-bit occupancy counter
* 8 × 8-bit memory
* 3-state FSM for FIFO status

### FSM States

```text
EMPTY
  │
  │ write
  ▼
PARTIAL
  │
  │ write until full
  ▼
FULL
```

* **EMPTY** — No data available for reading.
* **PARTIAL** — FIFO contains data and has available space.
* **FULL** — FIFO has reached maximum capacity.

Read and write operations are controlled using `rd_en` and `wr_en`.

## Architecture

```text
             ┌─────────────────┐
 wr_en ─────►│                 │
 rd_en ─────►│   FSM CONTROL   │
             │ EMPTY/PARTIAL/  │
             │ FULL            │
             └───────┬─────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │      FIFO DATAPATH     │
        │                        │
        │  Memory                │
        │  Write Pointer         │
        │  Read Pointer          │
        │  Occupancy Counter     │
        └────────────────────────┘
```

The FSM tracks the FIFO's occupancy state, while the datapath handles memory access, pointer movement, and element counting.

## Features

* Synchronous operation
* Reset support
* Circular read/write pointers
* Full and empty detection
* Read/write protection at FIFO boundaries
* Simultaneous read and write support
* Parameterized data width and FIFO depth
* Verilog testbench for functional verification

## Verification

The testbench verifies:

1. Reset and initial `EMPTY` state
2. Single and multiple writes
3. FIFO reads and FIFO ordering
4. Transition from `EMPTY → PARTIAL`
5. Transition from `PARTIAL → FULL`
6. Transition from `FULL → PARTIAL`
7. Transition from `PARTIAL → EMPTY`
8. Write attempt while `FULL`
9. Read attempt while `EMPTY`
10. Simultaneous read and write
11. Circular pointer wrap-around

### Expected FIFO behavior

```text
Reset
  ↓
EMPTY
  ↓ write
PARTIAL
  ↓ write until capacity reached
FULL
  ↓ read
PARTIAL
  ↓ read until empty
EMPTY
```

## Files

```text
├── fifo_fsm.v
├── fifo_fsm_tb.v
└── README.md
```

## Tools

* **Verilog HDL**
* **EDA Playground / Verilog simulator**
* **EPWave** for waveform inspection

## Learning Objectives

This project demonstrates understanding of:

* Finite State Machines
* Sequential and combinational RTL
* Non-blocking assignments
* Circular buffers
* Read/write pointers
* FIFO occupancy tracking
* Boundary-condition handling
* RTL testbench development
* Waveform-based verification

## Future Improvements

* Add SystemVerilog assertions
* Improve parameterization for arbitrary FIFO depths
* Add coverage-driven verification
* Implement an asynchronous dual-clock FIFO
* Synthesize and analyze area/timing
