# Simulation Waveform Guide

This document explains the simulation waveforms generated during the verification of the pipelined 32-bit MIPS Processor. The simulation has been divided into five waveform sections, each highlighting a different aspect of processor execution.

---

# Signals Used

| Signal                | Description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| **clk**               | System clock driving the processor.                                                                  |
| **reset**             | Initializes the processor and clears all pipeline registers.                                         |
| **PC_out**            | Current Program Counter value. Increments by 4 for every instruction unless a branch or jump occurs. |
| **IF_ID_Instr**       | Instruction stored in the IF/ID pipeline register after the Fetch stage.                             |
| **ID_EX_Instr**       | Instruction entering the Execute stage.                                                              |
| **EX_MEM_ALU_Result** | ALU output stored after the Execute stage.                                                           |
| **MEM_WB_ALU_Result** | ALU result forwarded to the Write Back stage.                                                        |
| **WB_Result**         | Final value written back into the register file.                                                     |
| **Fwd_A**             | Forwarding control for ALU input A.                                                                  |
| **Fwd_B**             | Forwarding control for ALU input B.                                                                  |
| **Stall**             | Indicates pipeline stalling due to a load-use hazard.                                                |
| **Flush**             | Flushes incorrect instructions after hazards or control transfers.                                   |
| **Branch_Sel**        | High when a branch instruction is taken.                                                             |
| **Jump_Sel**          | High when a jump instruction is executed.                                                            |

---

# Waveform 1 – Pipeline Filling

This waveform demonstrates the normal filling of the five-stage pipeline.

Observations:

* After reset, `PC_out` starts from 0.
* The Program Counter increments by 4 every clock cycle.
* Instructions first appear in `IF_ID_Instr`.
* One clock later the same instruction appears in `ID_EX_Instr`.
* After Execute, ALU outputs appear in `EX_MEM_ALU_Result`.
* One stage later they appear in `MEM_WB_ALU_Result`.
* Finally the value is written back and becomes visible as `WB_Result`.

This waveform verifies that the pipeline is operating correctly and that instructions are progressing through all five stages without hazards.

---

# Waveform 2 – Normal Instruction Execution

This section shows arithmetic, logical and memory instructions executing one after another.

Observations:

* Load (`lw`) instructions populate registers with values stored in Data Memory.
* Arithmetic and logical instructions produce ALU outputs visible in `EX_MEM_ALU_Result`.
* These values later appear in `MEM_WB_ALU_Result` and finally in `WB_Result`.
* Store (`sw`) instructions write register values into Data Memory instead of the register file. Therefore they do not produce new values in `WB_Result`.

The expected ALU outputs for every instruction are listed in the comments of `InstrMem.v`, making it easy to compare the waveform with the intended processor behavior.

---

# Waveform 3 – Data Forwarding

This waveform demonstrates the operation of the forwarding unit.

Observations:

* Consecutive dependent instructions are executed without inserting pipeline stalls.
* `Fwd_A` and `Fwd_B` become non-zero whenever an operand must be forwarded from a later pipeline stage.
* Instead of waiting for Write Back, the ALU receives the most recent result directly from EX/MEM or MEM/WB.

This confirms that the forwarding unit successfully resolves Read-After-Write (RAW) hazards.

---

# Waveform 4 – Stall and Flush

This waveform demonstrates hazard detection for load-use hazards.

Observations:

* `Stall` becomes HIGH when an instruction requires data that is still being loaded from memory.
* The Program Counter stops incrementing during the stall cycle.
* The IF/ID pipeline register is held constant.
* A bubble (NOP) is inserted into the pipeline by clearing the control signals.
* `Flush` is asserted to remove the incorrect instruction from the pipeline.

This ensures that dependent instructions execute only after valid data becomes available.

---

# Waveform 5 – Branch and Jump Control Hazards

This waveform demonstrates control hazard handling.

Observations:

* `Branch_Sel` becomes HIGH when the branch condition is satisfied.
* `Jump_Sel` becomes HIGH during jump instructions.
* Once a control transfer occurs, `Flush` clears instructions that were fetched from the wrong path.
* `PC_out` changes to the branch or jump target address instead of continuing sequentially.

This verifies correct implementation of branch and jump handling in the processor.

---

# Instruction Verification

The expected output of every instruction is already documented inside `InstrMem.v`.

Each instruction includes comments showing:

* Assembly instruction
* Expected ALU output
* Register write result
* Memory write result (for Store instructions)

These comments can be directly compared with the simulation waveform to verify processor correctness.

---

# Summary

The complete simulation demonstrates:

* Correct instruction fetching
* Proper pipeline progression
* Correct arithmetic and logical execution
* Successful register write-back
* Correct memory read/write operations
* Working forwarding unit
* Correct stall insertion
* Proper pipeline flushing
* Correct branch and jump handling

Together, these waveforms verify the functionality of the complete five-stage pipelined MIPS processor.
