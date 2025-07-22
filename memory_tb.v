`timescale 1ns / 1ps

module memory_tb;

reg clk, wt_en, rst;
reg [7:0] wt_addr, rd_addr;
reg [15:0] data_wt;
wire [15:0] read_out;

memory dut (.clk(clk), .wt_en(wt_en), .rst(rst), .wt_addr(wt_addr), .rd_addr(rd_addr), .data_wt(data_wt), .read_out(read_out));

initial begin
    forever #5 clk = ~clk;
end

initial begin
    clk = 0;
    wt_en = 0;
    rst = 0;
    wt_addr = 0;
    rd_addr = 0;
    data_wt =0;
    
    #10; rst = 1;
    #20; rst = 0;
    
    #1 wt_en = 1;
     wt_addr = 8'h10; data_wt = 16'hAAAA;
    @(posedge clk); #1; 
    
    wt_addr = 8'h05; data_wt = 16'h1234;
    @(posedge clk);
    #1;
    
    wt_en = 0;
    
    rd_addr = 8'h10;
    #5;

    rd_addr = 8'h05;
    #5;
    
    rd_addr = 8'h00; 
    #5;
    #20;
    $finish;
end

initial begin
    $dumpfile("memory_tb.vcd");
    $dumpvars(0, memory_tb);
end

endmodule
