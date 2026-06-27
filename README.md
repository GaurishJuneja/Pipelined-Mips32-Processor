# 32-bit Pipelined MIPS Processor in Verilog

A five-stage pipelined MIPS32 processor designed in Verilog HDL featuring instruction pipelining, hazard detection, data forwarding, branch handling, and jump support. The processor was verified through simulation using a comprehensive instruction set covering arithmetic, logical, memory, data hazard, and control hazard operations.

---

## Features

* 32-bit MIPS Processor
* Five-stage instruction pipeline

  * Instruction Fetch (IF)
  * Instruction Decode (ID)
  * Execute (EX)
  * Memory Access (MEM)
  * Write Back (WB)
* Data Hazard Detection
* Data Forwarding Unit
* Pipeline Stall Logic
* Pipeline Flush Logic
* Branch and Jump Support
* Register File with 32 Registers
* Instruction Memory and Data Memory
* Modular Verilog implementation
* Fully verified through simulation

---

## Pipeline Architecture

The processor follows the classic five-stage MIPS pipeline.

```
Instruction Memory
        │
        ▼
+---------+
|   IF    |
+---------+
     │
     ▼
+---------+
|   ID    |
+---------+
     │
     ▼
+---------+
|   EX    |
+---------+
     │
     ▼
+---------+
|  MEM    |
+---------+
     │
     ▼
+---------+
|   WB    |
+---------+
```

Multiple instructions execute simultaneously in different pipeline stages, improving processor throughput compared to a single-cycle implementation.

<img width="1442" height="727" alt="mips_32_pipelined" src="https://github.com/user-attachments/assets/25b5ae52-f9e0-41d4-b7fb-efc81283ec07" />


---

## Supported Instruction Types

The instruction program is implemented inside **InstrMem.v** and includes a variety of instruction formats to verify different processor functionalities.

### Arithmetic Instructions

* ADD
* ADDI
* MULT
* DIV

### Logical Instructions

* ANDI
* XOR
* NOR

### Shift Instructions

* SLL
* SRL
* SRA

### Comparison

* SLT

### Memory Instructions

* LW
* SW

### Control Instructions

* BEQ
* J

The expected output of every instruction is documented within **InstrMem.v**, making simulation results easy to verify.

---

# Hazard Handling

The processor implements hardware support for common pipeline hazards.

### Data Forwarding

The forwarding unit resolves Read-After-Write (RAW) hazards by forwarding ALU results directly from later pipeline stages instead of waiting for register write-back.

### Stall Logic

Load-use hazards are detected automatically. The processor temporarily stalls the pipeline and inserts a bubble until valid data becomes available.

### Pipeline Flush

Incorrectly fetched instructions following a taken branch or jump are flushed from the pipeline to ensure correct program execution.

---

# Project Directory

```
MIPS32_Pipelined_Processor
│
├── src
│   ├── ALU.v
│   ├── ALUController.v
│   ├── Controller.v
│   ├── Data_Forwarding.v
│   ├── DataMem.v
│   ├── EX_Stage.v
│   ├── Hazard_Detection.v
│   ├── ID_Stage.v
│   ├── IF_Stage.v
│   ├── InstrMem.v
│   ├── MIPS32_Processor.v
│   ├── Mux2_1.v
│   ├── Mux4_1.v
│   ├── PipeReg.v
│   ├── PipeReg_Hazard_Controlled.v
│   ├── RegFile.v
│   └── SignExtend.v
│
├── tb
│   └── tb_MIPS32_Processor.v
│
├── waveforms
│   ├── MIPS_Waveform_1.png
│   ├── MIPS_Waveform_2.png
│   ├── MIPS_Waveform_3.png
│   ├── MIPS_Waveform_4.png
│   ├── MIPS_Waveform_5.png
│   └── Waveform_Explanation.md
│
└── README.md
```

---

# Source File Description

| File                            | Description                                                                                                            |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **MIPS32_Processor.v**          | Top-level module connecting all pipeline stages, memories and hazard handling units.                                   |
| **IF_Stage.v**                  | Implements the Instruction Fetch stage, Program Counter logic, branch/jump selection and instruction memory interface. |
| **ID_Stage.v**                  | Decodes instructions, reads register operands, generates immediate values and control signals.                         |
| **EX_Stage.v**                  | Performs arithmetic, logical and shift operations using the ALU while supporting operand forwarding.                   |
| **Controller.v**                | Main control unit that decodes instruction opcodes and generates pipeline control signals.                             |
| **ALUController.v**             | Decodes ALU operations for R-type and immediate instructions.                                                          |
| **ALU.v**                       | Performs arithmetic, logical, comparison and shift operations.                                                         |
| **RegFile.v**                   | Implements the 32-register register file with synchronous writes and asynchronous reads.                               |
| **InstrMem.v**                  | Read-only instruction memory containing the complete verification program.                                             |
| **DataMem.v**                   | Memory module used for load and store instructions.                                                                    |
| **Data_Forwarding.v**           | Detects data dependencies and generates forwarding control signals.                                                    |
| **Hazard_Detection.v**          | Detects load-use hazards and generates stall and flush signals.                                                        |
| **PipeReg.v**                   | Standard pipeline register used between pipeline stages.                                                               |
| **PipeReg_Hazard_Controlled.v** | Pipeline register supporting both stall and flush operations. Used for the IF/ID stage.                                |
| **Mux2_1.v**                    | Parameterized 2-to-1 multiplexer.                                                                                      |
| **Mux4_1.v**                    | Parameterized 4-to-1 multiplexer used for forwarding selection.                                                        |
| **SignExtend.v**                | Extends 16-bit immediates to 32 bits.                                                                                  |

---

# Simulation

Simulation is performed using the supplied testbench:

```
tb/tb_MIPS32_Processor.v
```

The testbench executes the complete instruction sequence stored in the instruction memory and verifies:

* Pipeline filling
* Register write-back
* ALU operations
* Load and Store instructions
* Data forwarding
* Stall generation
* Flush generation
* Branch execution
* Jump execution

---

# Waveforms

Five waveform snapshots are included inside the **waveforms** directory.

| Waveform       | Description                                          |
| -------------- | ---------------------------------------------------- |
| **Waveform 1** | Pipeline filling and normal instruction flow         |
| **Waveform 2** | Arithmetic, logical and memory instruction execution |
| **Waveform 3** | Data forwarding during RAW hazards                   |
| **Waveform 4** | Stall and flush generation during load-use hazards   |
| **Waveform 5** | Branch and jump execution with pipeline flushing     |

A detailed explanation of every signal shown in the waveforms is available in:

```
waveforms/Waveform_Explanation.md
```

```
https://github.com/GaurishJuneja/Pipelined-Mips32-Processor/tree/main/Waveforms
```

---

# Verification

The processor was verified using a comprehensive instruction sequence that tests:

* Arithmetic operations
* Logical operations
* Shift operations
* Register write-back
* Memory read/write
* Data hazards
* Control hazards
* Branch instructions
* Jump instructions

Expected outputs for each instruction are documented as comments inside **InstrMem.v**, allowing direct comparison with simulation waveforms.

---

# Future Improvements

Possible extensions to this processor include:

* Additional MIPS instructions
* Branch prediction
* Cache memory
* Multiply/Divide pipeline optimization
* Exception and interrupt handling
* FPGA implementation and hardware validation

---

# Author

Gaurish Juneja
