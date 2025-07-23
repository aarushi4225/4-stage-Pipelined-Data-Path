`timescale 1ns / 1ps

module alu (
    input [3:0] sel,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] Z,
    input clk,
    input rst
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        Z = 16'h0000; 
    end 
    else 
    begin
        case(sel)
            4'h0 : Z = A + B;     // ADD
            4'h1 : Z = A - B;     // SUB
            4'h2 : Z = A * B;     // MUL
            4'h3 : Z = A / B;     // DIV
            4'h4 : Z = A >> 1;    // SRA (Right SHIFT A)
            4'h5 : Z = A << 1;    // SLA (Left SHIFT A)
            4'h6 : Z = A & B;     // AND
            4'h7 : Z = A | B;     // OR
            4'h8 : Z = A ^ B;     // XOR
            4'h9 : Z = ~A;        // INV
            4'hA : Z = ~(A^B);    // XNOR
            4'hB : Z = ~(A&B);    // NAND
            4'hC : Z = {A[0], A[7:1]}; // RRA (Right Rotate A)
            4'hD : Z = {A[6:0], A[7]}; // LRA (Left Rotate A)
            4'hE : Z = (A > B ? 16'd1 : 16'd0); // GT (Greater Than)
            4'hF : Z = (A == B ? 16'd1 : 16'd0); // EQ (Equal To)
            default : Z = 16'hxxxx;
         endcase
     end
end

endmodule