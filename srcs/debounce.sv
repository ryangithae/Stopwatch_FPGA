`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 08:27:09 PM
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce#(
        parameter DEBOUNCE_LIMIT = 1000000
    )
    (
    input clk,
    input bouncy,
    output debounced
    );
    reg [$clog2(DEBOUNCE_LIMIT) - 1:0] clock_divider = '0;
    reg r_button = '0;
    
    always_ff @(posedge clk) begin
        if (bouncy != r_button && clock_divider != '1)
            clock_divider <= clock_divider + 1'b1;
        else if (clock_divider == '1) begin
            r_button <=  bouncy;
            clock_divider = '0;
        end else
            clock_divider <= '0;      
    end
    
    assign debounced = r_button;
    
endmodule
