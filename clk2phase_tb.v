`timescale 1ns / 1ps

module clk2phase_tb;
reg master_clk;
wire ph1;
wire ph2;

clk2phase dut (.master(master_clk), .phi1(ph1), .phi2(ph2));
initial begin
master_clk = 0;
forever #5 master_clk = ~master_clk;
end
initial begin
       #100;
        $finish;
    end
initial begin
        $dumpfile("clk2phase_tb.vcd");
        $dumpvars(0, clk2phase_tb); 
    end

endmodule
