`timescale 1ns / 1ps

module memory(
input clk, rst, wt_en,
input [15:0] data_wt,
input [7:0] wt_addr,
input [7:0] rd_addr,
output wire [15:0] read_out);

reg [15:0] mem [0:255];

always @ (posedge clk or posedge rst) begin : mem_writer
    integer i;
    if (rst) begin
        for (i = 0; i < 256; i = i + 1) mem[i] <= 0;
    end
    else begin
        if (wt_en) mem[wt_addr] <= data_wt;
    end
end

assign read_out = mem[rd_addr];

endmodule
