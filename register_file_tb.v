`timescale 1ns / 1ps

module register_file_tb();
    reg clk;
    reg rst;
    reg [4:0] rs_add1;
    reg [4:0] rs_add2;
    reg [4:0] rd_add;
    reg enw;
    reg [15:0] write_data;
    wire [15:0] read1;
    wire [15:0] read2;

register_file dut (.clk(clk), .rst(rst), .rs_add1(rs_add1), .rs_add2(rs_add2),
.read1(read1), .read2(read2), .rd_add(rd_add), .enw(enw), .write_data(write_data));

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
rst = 0;
rs_add1 = 5'b0;
rs_add2 = 5'b0;
rd_add = 5'b0;
enw = 0;
write_data = 16'h0;

#10 rst = 1;
#20 rst = 0;

//writing
@(posedge clk);
#1;

enw = 1;
rd_add = 5'd1; write_data = 16'hAAAA;
@(posedge clk);
#1;
rd_add = 5'd5; write_data = 16'hBBBB;
@(posedge clk); 
#1;
rd_add = 5'd10; write_data = 16'hCCCC;
@(posedge clk); 
#1;

enw = 0;

//reading
rs_add1 = 5'd1; rs_add2 = 5'd5;
#5;
$display("Time=%0t: Reading R1 (expected AAAA): %h, R5 (expected BBBB): %h", $time, read1, read2);

rs_add1 = 5'd10; rs_add2 = 5'd20;
#5;

$display("Time=%0t: Reading R10 (expected CCCC): %h, R20 (expected 0000): %h", $time, read1, read2);
@(posedge clk);
#1;
enw = 0;
rs_add1 = 5'd0; rs_add2 = 5'd1;
#5;
$display("Time=%0t: Reading R0 (expected 0000): %h, R1 (expected AAAA): %h", $time, read1, read2);
#20; 
$finish;
end

initial begin 
$dumpfile("register_file_tb.vcd");
$dumpvars(0, register_file_tb);
end  

endmodule
