# ⚓ Digital Battleship — DE10-Lite FPGA

<p align="center">
  <a href="README.md">🇧🇷 Português</a> | 🇺🇸 English
</p>

A hardware implementation of the classic **Battleship** game developed in **Verilog HDL** for the **Intel DE10-Lite FPGA (MAX 10 — 10M50DAF484C7G)**. The project features VGA graphics, finite state machines (FSMs), an internal game-board memory, score management, and a modular hardware architecture.

---

> A modular FPGA implementation of Battleship featuring VGA graphics, FSM-based control, and internal memory management.

## 🎮 Game Overview

The game is played in **challenge mode**:

* **Player 1** places all ships on the board.
* **Player 2** attempts to locate and sink them without knowing their positions.

### Features

* 8×8 game board
* Ship placement using switches and a confirmation button
* VGA graphics output
* Score tracking
* Win/lose detection
* Fully modular architecture
* Implemented entirely in Verilog HDL

The game ends when either:

* All ships have been destroyed; or
* The player's score reaches zero.

---

## 🚢 Ships

| Ship             | Size    | Code    |
| ---------------- | ------- | ------- |
| Aircraft Carrier | 5 cells | `2'b00` |
| Frigate          | 4 cells | `2'b01` |
| Corvette         | 3 cells | `2'b10` |
| Submarine        | 2 cells | `2'b11` |

---

## 🎨 Color Encoding

| Color  | Code    | Meaning                 |
| ------ | ------- | ----------------------- |
| White  | `2'b11` | Intact ship             |
| Blue   | `2'b01` | Untouched water         |
| Red    | `2'b00` | Ship hit                |
| Yellow | `2'b10` | Missed shot (water hit) |

Each board cell stores **4 bits**:

* **[3:2]** → Cell color
* **[1:0]** → Ship type

---

## 🔧 Hardware Platform

* **Board:** Intel DE10-Lite (MAX 10 — 10M50DAF484C7G)
* **Video Output:** VGA
* **Inputs:** 6 switches + 2 push buttons
* **Displays:** Four 7-segment displays

### Hardware Mapping

| Component | Function       |
| --------- | -------------- |
| `SW[2:0]` | Column (1–8)   |
| `SW[5:3]` | Row (A–H)      |
| `KEY[0]`  | Reset          |
| `KEY[1]`  | Confirm        |
| `HEX0`    | Column display |
| `HEX1`    | Row display    |
| `HEX4`    | Score (units)  |
| `HEX5`    | Score (tens)   |
| VGA       | 8×8 game board |

---

## 🏗️ System Architecture

### Game Flow

```text
Reset
    ↓
Initialize Board (Blue)
    ↓
Player 1 - Ship Placement
    ↓
Player 2 - Attack Phase
    ↓
End of Game
```

### Project Modules

| Module                    | Description                                                   |
| ------------------------- | ------------------------------------------------------------- |
| `main`                    | Top-level module integrating the entire system                |
| `mef_principal`           | Main finite state machine controlling the game flow           |
| `MEFPlayer1`              | Ship placement controller                                     |
| `MEFPlayer2`              | Attack phase controller                                       |
| `Memoria`                 | 64×4-bit register-based game board memory                     |
| `Registrador4Bits`        | 4-bit register with enable                                    |
| `Registrador6Bits`        | Stores the last attack coordinates                            |
| `contador_posicionamento` | Controls the ship placement sequence                          |
| `contador_destruicao`     | Tracks ship hits and detects when ships are destroyed         |
| `contador_pontuacao`      | Updates the score and detects game over                       |
| `contador_64_blocos`      | Iterates through all 64 board positions during initialization |
| `verifica_tiro`           | Determines whether a shot is a hit, miss, or repeated attack  |
| `resetDoAmarelo`          | Clears the previous yellow marker after an invalid shot       |
| `debounce`                | Removes button bouncing                                       |
| `detector_borda`          | Generates a single pulse on the rising edge                   |
| `display_letra`           | Seven-segment decoder for board rows (A–H)                    |
| `display_numero`          | Seven-segment decoder for numbers                             |
| `display_pontuacao`       | Displays the current score                                    |
| `FlipFlopD`               | D Flip-Flop used to build registers                           |
| `mux1bit`                 | 2-to-1 multiplexer (1 bit)                                    |
| `mux4Inp1Bit`             | 2-to-1 multiplexer (4 bits)                                   |
| `mux2Bits`                | 4-to-1 multiplexer (1 bit)                                    |
| `mux4para1_4bits`         | 4-to-1 multiplexer (4 bits)                                   |
| `mux2para1_6bits`         | 2-to-1 multiplexer (6 bits)                                   |
| `CodMefSigToSlc`          | Encodes FSM control signals for multiplexer selection         |
| `parametros.v`            | Global definitions for colors and ship types                  |
| `VGA_interface`           | VGA interface module (provided, do not modify)                |

---

## 📁 Project Structure

```text
/
├── main.v
├── parametros.v
├── mef_principal.v
├── MEFPlayer1.v
├── MEFPlayer2.v
├── Memoria.v
├── Registrador4Bits.v
├── Registrador6Bits.v
├── contador_posicionamento.v
├── contador_destruicao.v
├── contador_pontuacao.v
├── contador_64_blocos.v
├── verifica_tiro.v
├── resetDoAmarelo.v
├── debounce.v
├── detector_borda.v
├── display_letra.v
├── display_numero.v
├── display_pontuacao.v
├── FlipFlopD.v
├── mux1bit.v
├── mux4Inp1Bit.v
├── mux2Bits.v
├── mux4para1_4bits.v
├── mux2para1_6bits.v
├── CodMefSigToSlc.v
├── VGA_interface.v
└── pbl323.qsf
```

---
