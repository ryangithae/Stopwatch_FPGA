# Stopwatch_FPGA
# FPGA Stopwatch (Basys3)

An FPGA-based stopwatch implementation designed for the **Basys3 FPGA development board**, leveraging the on-board **100 MHz clock** for precise timekeeping.  

A fully functional FPGA-based stopwatch built on the Basys3 board, capable of tracking time with microsecond precision. The stopwatch features a state-machine controlled design with RUN, PAUSE, and RESET modes, displayed on the four on-board seven-segment displays in the format SS:mS:µS. After every 99 seconds, the display resets while the on-board LEDs keep a binary tally of elapsed time blocks, allowing tracking of up to ~900 hours.

- **SS (2 digits)** → Counts seconds (00–99)  
- **mS (1 digit)** → Milliseconds  
- **µS (1 digit)** → Microseconds  

##  Features

- **Accurate Timing**  
  - Time is derived directly from the **100 MHz FPGA clock**.  
  - Cycle counters ensure precise detection of µs, mS, and s intervals.  

- **State Machine Control**  
  - `RESET` → Default state on power-up; clears stopwatch.  
  - `RUN` → Stopwatch runs normally.  
  - `PAUSE` → Freezes the display at the current time.  

- **Extended Timekeeping with LEDs**  
  - After **99 seconds**, the stopwatch resets its display, and the **LEDs increment in binary**.  
  - All **15 LEDs** are utilized, enabling tracking of elapsed time up to **~900 hours**.  

- **Resource-Efficient Design**  
  - Counters are sized to fit timing requirements without unnecessary logic overhead.  
  - Clean finite state machine for reliable transitions.  

![IMG_0745](https://github.com/user-attachments/assets/c95aad0d-b7bc-4d9b-a973-95d4495b0d9a)
