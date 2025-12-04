# VHDL_Civilization

A Basys 3 FPGA game developed in VHDL, featuring a real-time, interactive grid where players can place different building types using the board’s physical buttons and switches.\ 
The game is displayed live through the VGA output.

## Project Overview

VHDL_Civilization is a hardware-based grid management game implemented entirely in VHDL for the Basys 3 FPGA board.\
The player interacts with a grid of squares and can select individual tiles and place one of three building types:

- Factory
- Farm
- City
\
All interaction is done using the physical buttons and switches on the Basys 3, and the game state is rendered in real time over VGA.\
This project demonstrates:

- Real-time VGA graphics generation
- Hardware-based user input handling
- Grid-based game logic
- Digital design using VHDL on FPGA hardware

# Gameplay & Controls
## Grid Interaction

- The game consists of a grid of visible squares.
- Each square can hold one building.
- The currently selected square is controlled using the directional buttons on the Basys 3 board.

## Building Selection

The switches are used to select which building type you want to place ( switches 15 and 14 ):
- One switch setting corresponds to Factory 10 (binary)
- One switch setting corresponds to Farm 11 (binary)
- One switch setting corresponds to City 01 (binary)

## Building Placement

After selecting:
- Move to the desired square using the directional buttons.
- Select the building type using the switches.
- Press the center button (middle button) to place the building.

## Display

- The grid and buildings are displayed in real time using the VGA output.
- Any placement or movement is immediately reflected on screen.

## Hardware Requirements

- Basys 3 FPGA Board
- VGA Monitor
- VGA Cable
- Xilinx Vivado (or compatible FPGA toolchain)

## Technologies Used

- VHDL — Core logic and hardware design
- FPGA (Basys 3) — Execution hardware
- VGA Output — Real-time visual display
- Physical Input Handling — Buttons & switches
- Python — for image processing

## Educational Value

This project is well suited for:

- Learning VHDL in a real interactive application
- Understanding VGA signal generation
- Hands-on experience with FPGA input/output
- Implementing grid-based logic in hardware
- Digital system integration and real-time visualization
