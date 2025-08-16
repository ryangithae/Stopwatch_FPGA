`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025 10:35:02 AM
// Design Name: 
// Module Name: tb
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


module tb();

reg clk;
reg reset;
wire [3:0] anode;
wire [6:0] cathode;
wire dp;
wire [15:0] LED;

initial begin
    clk = 1'b0;
    forever begin
        #1 clk = ~clk;
    end
end

stopwatch_top my_stopwatch(
    .clk(clk),
    .reset(reset),
    .start(1'b0),
    .stop(1'b0),
    .pause(1'b0),
    .anode(anode),
    .cathode(cathode),
    .dp(dp),
    .LED(LED)
);
initial begin
    reset = 1'b0;
    #10000000
    $finish;
end
endmodule
