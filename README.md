# SPI Master-Slave Communication Using VHDL

## Overview

This project implements the Serial Peripheral Interface (SPI) protocol using VHDL. The design includes an SPI Master Transmitter and SPI Slave Receiver capable of transferring 8-bit data serially through MOSI, SCLK, and CS lines.

The design was developed and simulated using Xilinx Vivado.

---

## Features

* SPI Master Implementation
* SPI Slave Receiver
* SPI Clock Generator
* FSM-Based Control Logic
* Master Shift Register
* Slave Shift Register
* Multi-Slave Support
* Chip Select (CS) Control
* Simulation Testbench

---

## SPI Signals

```text
MOSI  - Master Out Slave In
SCLK  - Serial Clock
CS    - Chip Select (Active Low)
```

---

## Project Structure

```text
SPI_Project/
│
├── spi_clk_generator.vhd
├── spi_fsm.vhd
├── spi_shift_reg.vhd
├── spi_slave_rx.vhd
├── spi_top.vhd
├── tb_spi_top.vhd
│
└── README.md
```

---

## Design Description

### SPI Clock Generator

Generates the SPI serial clock (SCLK) and timing tick signals.

### SPI FSM

Controls:

* Chip Select (CS)
* Data Loading
* Data Shifting
* Transfer Completion

### SPI Shift Register

Performs parallel-to-serial conversion and transmits data through MOSI.

### SPI Slave Receiver

Receives serial data on MOSI and reconstructs the original 8-bit data.

---

## Simulation Example

```text
Data Sent     : A5h
Binary        : 10100101

MOSI Output   : 1 0 1 0 0 1 0 1

Data Received : A5h
Status        : PASS
```

---

## Tools Used

* VHDL
* Xilinx Vivado
* Vivado Simulator

---

## Applications

* Sensor Interfaces
* ADC/DAC Communication
* FPGA-to-Microcontroller Communication
* Embedded Systems

---

## Future Improvements

* Full-Duplex SPI
* MISO Support
* Configurable SPI Modes (0,1,2,3)
* FIFO-Based SPI Interface

---

## Author

Developed as part of FPGA and Digital Communication learning using VHDL and Xilinx Vivado.
