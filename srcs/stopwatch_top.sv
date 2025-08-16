`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ryan Githae
// 
// Create Date: 08/12/2025 08:27:09 PM
// Design Name: Stopwatch
// Module Name: stopwatch_top
// Project Name: Stopwatch
// Target Devices: Basys 3 FPGA
// Tool Versions: Vivado 2024.2
// Description: Stopwatch implementation using LEDs and Seven Segment Display
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stopwatch_top
        #(
          parameter NUM_SEGMENTS = 4,
          parameter BITS = 16
        )
        (
       input clk,
       input reset,
       input start,
       input stop,
       output logic [NUM_SEGMENTS -1:0] anode,
       output logic [6:0] cathode,
       output dp,
       output [15:0] LED
    );
    
    // Clock frequency
    localparam int CLK_FREQ_HZ = 100_000_000; // 100 MHz
    
    // Derived thresholds
    localparam int MICROSEC_TICKS = CLK_FREQ_HZ / 1_000_000; // 100
    localparam int MILLISEC_TICKS = CLK_FREQ_HZ / 1_000;     // 100,000
    localparam int SEC_TICKS      = CLK_FREQ_HZ;             // 100,000,000
    
    // Counters
    reg [$clog2(MICROSEC_TICKS)-1:0] microsec_counter = '0;
    reg [$clog2(MILLISEC_TICKS)-1:0] millisec_counter = '0;
    reg [$clog2(SEC_TICKS)-1:0]      sec_counter     = '0;
    
    typedef enum bit[1:0] {RUN, PAUSE,RESET} state_t;
    
    state_t state;
    
    reg [3:0] microseconds = '0;
    reg [3:0] milliseconds = '0;
    reg [6:0] seconds = '0;
    reg [15:0] LED_wrap = '0;
    
    wire [14:0] watch_time;
    logic [15:0] encoded;
    
    wire start_debounced;
    wire stop_debounced;
    wire reset_debounced;
    
    initial begin
        state <= RESET;
    end
    
    always_ff @(posedge clk) begin
    case (state)
        RUN: begin
            if (reset_debounced == 1'b1)begin
                state <= RESET;
            end else if (stop_debounced == 1'b1) begin
                state <= PAUSE;
            end else
                state <= RUN;
        
            if (microsec_counter == MICROSEC_TICKS - 1) begin
                microseconds <= microseconds + 1'b1;
                microsec_counter <= '0;
            end else
                microsec_counter <= microsec_counter + 1'b1;
       
            if (millisec_counter == MILLISEC_TICKS-1) begin
                milliseconds <=  milliseconds + 1'b1;
                millisec_counter <= '0;
            end else
                millisec_counter <= millisec_counter + 1'b1;
            
            if (sec_counter == SEC_TICKS - 1) begin
                seconds <= seconds + 1'b1;
                sec_counter <= '0;
            end else
                sec_counter <= sec_counter + 1'b1;
            
            if (seconds > 7'd99)begin
                seconds <= 0;
                LED_wrap <= LED_wrap + 1'b1;
            end
       
            if (milliseconds > 4'd9)
                milliseconds <= 0;
            
            if (microseconds >4'd9)
                microseconds <= 0;
                
      end
      PAUSE: begin
            seconds <=  seconds;
            milliseconds <= milliseconds;
            microseconds <= microseconds;
            if (start_debounced == 1'b1)
                state <= RUN;
            else if (reset_debounced == 1'b1)
                state <= RESET;
            else
                state <= PAUSE;
      end
      RESET: begin
            microseconds <= '0;
            milliseconds <= '0;
            seconds <= '0;
            microsec_counter <= '0;
            millisec_counter <= '0;
            sec_counter <= '0;
            LED_wrap <= '0;
            if (start_debounced) 
                state <= RUN;
            else
                state <= RESET; 
     end
     endcase
    end
    
    sevenseg  
        #(
            .NUM_SEGMENTS(NUM_SEGMENTS),
            .BITS(BITS)
        )
        my_sevenseg(
            .clk(clk),
            .rst(reset_debounced),
            .encoded(encoded),
            .cathode(cathode),
            .anode(anode),
            .decimal_point(dp)
        );
       
        always_comb begin
            // seconds is 0..99 so /10 and %10 are small constant divides
            encoded[15:12] = seconds / 10;      // tens of seconds
            encoded[11: 8] = seconds % 10;      // seconds units
            encoded[7 : 4] = milliseconds;      // single decimal digit
            encoded[3 : 0] = microseconds;      // single decimal digit
        end
       
       debounce start_debounce (
            .clk(clk),
            .bouncy(start),
            .debounced(start_debounced)
       );
       
       debounce stop_debounce (
            .clk(clk),
            .bouncy(stop),
            .debounced(stop_debounced)
       );
       
       debounce reset_debounce(
            .clk(clk),
            .bouncy(reset),
            .debounced(reset_debounced)
       );
    
    assign LED = LED_wrap;
    assign watch_time = {seconds,milliseconds,microseconds};
endmodule
