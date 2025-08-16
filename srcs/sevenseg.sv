`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 08:27:09 PM
// Design Name: 
// Module Name: sevenseg
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


module sevenseg
    #(
        parameter NUM_SEGMENTS = 4,
        parameter BITS = 16
    )   
    (
    input clk,
    input rst,
    input wire [BITS-1: 0]encoded,
    output logic [6:0] cathode,
    output logic [NUM_SEGMENTS-1:0] anode,
    output logic decimal_point
    );
    
    reg [19:0] refresh_counter = '0;
    reg [1:0] activated_anode;
    reg [3:0] activated_cathode;
    
    always_ff @(posedge clk or posedge rst) begin
        if ( rst == 1 || refresh_counter == '1)
            refresh_counter <= '0;
        else
            refresh_counter <= refresh_counter + 1'b1;
     end
     
     assign activated_anode = refresh_counter[19:18];
     
     always_comb begin
        decimal_point = 1'b1;
        case(activated_anode)
            2'b00: begin
                anode = 4'b0111;
                activated_cathode = encoded[15:12];
            end
            2'b01: begin
                anode = 4'b1011;
                activated_cathode = encoded[11:8];
            end
            2'b10: begin
                anode = 4'b1101;
                activated_cathode = encoded[7:4];
            end
            2'b11: begin
                anode = 4'b1110;
                activated_cathode = encoded[3:0];
            end
          endcase
        end
        
        
          always_ff @(posedge clk) begin
             case (activated_cathode)
               4'h0: cathode[6:0] <= 7'b1000000;
               4'h1: cathode[6:0] <= 7'b1111001;
               4'h2: cathode[6:0] <= 7'b0100100;
               4'h3: cathode[6:0] <= 7'b0110000;
               4'h4: cathode[6:0] <= 7'b0011001;
               4'h5: cathode[6:0] <= 7'b0010010;
               4'h6: cathode[6:0] <= 7'b0000010;
               4'h7: cathode[6:0] <= 7'b1111000;
               4'h8: cathode[6:0] <= 7'b0000000;
               4'h9: cathode[6:0] <= 7'b0010000;
               default: cathode[6:0] <= 7'b1111111;
             endcase
           end
     
endmodule
