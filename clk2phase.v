`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2025 00:11:43
// Design Name: 
// Module Name: clk2phase
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


module clk2phase(
input master,
output reg phi1,
output reg phi2  );

initial begin
phi1 = 0;
phi2 = 0;
end

always@(posedge master) begin
#1 phi1<=1;
#4 phi1 <=0;
end

always @ (negedge master) begin
#1 phi2<=1;
#4 phi2<=0;
end

endmodule
