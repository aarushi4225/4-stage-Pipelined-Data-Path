`timescale 1ns / 1ps

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
