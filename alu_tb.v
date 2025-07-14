`timescale 1ns / 1ps

module alu_tb;
reg [7:0] tb_A;
reg [7:0] tb_B;
reg [3:0] tb_sel;
reg tb_clk;
wire [15:0] tb_z;

alu dut (tb_sel, tb_A, tb_B, tb_Z, tb_clk);
//clock
initial begin
tb_clk = 0;
forever #5 tb_clk = ~tb_clk;
end

initial begin
tb_A=8'h00;
tb_B = 8'h00;
tb_sel = 4'h0;

@(posedge tb_clk);
#1;
$monitor("%0t\t%b\t%h\t%h\t%h\t%s\t%h", $time, tb_clk, tb_A, tb_B, tb_sel, get_op_name(tb_sel), tb_Z);

tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h0;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h1;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h2;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h3;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h4;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h5;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h6;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h7;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h8;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'h9;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'hA;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'hB;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'hC;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'hD;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
 tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'hE;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 
tb_A = 8'd10;
tb_B = 8'd5;
tb_sel = 4'hF;
@(posedge tb_clk); #1;
tb_A = 8'd255;
tb_B = 8'd10;
@(posedge tb_clk); #1;
 $finish;
end

initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
end

endmodule
