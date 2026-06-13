# APB Protocol Testbench Practice

## Overview

This repository contains my APB (Advanced Peripheral Bus) protocol verification practice projects developed as part of my Design Verification learning journey.

The goal of this repository is to gain a strong understanding of:

* APB Protocol Architecture
* APB Read and Write Transactions
* Master-Slave Communication
* RTL Design and Verification
* Verilog/SystemVerilog Coding
* Testbench Development
* Protocol Checking
* Functional Verification Concepts

---

## APB Protocol Introduction

APB (Advanced Peripheral Bus) is part of the AMBA (Advanced Microcontroller Bus Architecture) family developed by ARM.

APB is designed for:

* Low bandwidth peripherals
* Low power consumption
* Simple control interfaces
* Register access operations

Typical APB peripherals include:

* UART
* SPI
* I2C
* GPIO
* Timers
* Watchdog Controllers

---

## APB Signals

### Global Signals

| Signal  | Description      |
| ------- | ---------------- |
| PCLK    | APB Clock        |
| PRESETn | Active Low Reset |

### Control Signals

| Signal  | Description            |
| ------- | ---------------------- |
| PSEL    | Slave Select           |
| PENABLE | Enable Phase Indicator |
| PWRITE  | Read/Write Indicator   |

### Address & Data Signals

| Signal | Description    |
| ------ | -------------- |
| PADDR  | Address Bus    |
| PWDATA | Write Data Bus |
| PRDATA | Read Data Bus  |

### Response Signals

| Signal  | Description         |
| ------- | ------------------- |
| PREADY  | Transfer Completion |
| PSLVERR | Error Indicator     |

---

## APB Transfer Phases

### Setup Phase

Master drives:

* PADDR
* PSEL
* PWRITE
* PWDATA (for write)

### Enable Phase

Master asserts:

* PENABLE

Slave responds using:

* PREADY
* PRDATA
* PSLVERR

---

## Repository Structure

```text
APB/
│
├── rtl/
│   ├── apb_slave.sv
│   ├── apb_memory.sv
│   └── ...
│
├── tb/
│   ├── apb_tb.sv
│   ├── generator.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   └── ...
│
├── sim/
│   ├── compile.do
│   ├── run.do
│   └── ...
│
└── waves/
```

---

## Verification Components

The testbench may include:

### Generator

Creates APB transactions.

### Driver

Converts transactions into APB bus activity.

### Monitor

Observes APB bus signals and reconstructs transactions.

### Scoreboard

Compares expected and actual behavior.

### Coverage

Tracks protocol functionality coverage.

---

## Test Scenarios

Implemented and planned test cases include:

### Write Tests

* Single Write
* Consecutive Writes
* Random Writes

### Read Tests

* Single Read
* Consecutive Reads
* Random Reads

### Corner Cases

* Invalid Address Access
* Back-to-Back Transfers
* Wait State Handling
* Reset During Transfer
* Error Response Verification

---

## Learning Objectives

Through this project I practiced:

* RTL Design
* Protocol Understanding
* SystemVerilog
* Assertions
* Verification Planning
* Functional Coverage
* Scoreboarding Techniques
* Debugging with Waveforms

---

## Tools Used

* SystemVerilog
* Verilog
* QuestaSim / ModelSim
* GTKWave
* Synopsys VCS (Optional)

---

## Future Enhancements

* UVM-Based APB Environment
* Functional Coverage Model
* Assertions (SVA)
* APB Master Agent
* APB Slave Agent
* Register Model Integration
* APB-to-AXI Bridge Verification

---

## Author

**Abhighnan Kuruva**

Design Verification Engineer

* Verilog
* SystemVerilog
* UVM
* AMBA Protocols
* Design Verification

---

## License

This project is intended for educational and learning purposes.
