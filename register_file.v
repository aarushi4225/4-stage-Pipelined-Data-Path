`timescale 1ns / 1ps

`timescale 1ns / 1ps

module register_file(
    input clk,
    input rst,
    //Read addressess
    input [4:0] rs_add1,
    input [4:0] rs_add2,
    //Data readong
    output [15:0] read1,
    output [15:0] read2,
    //Write
    input [4:0] rd_add,
    input enw, // Active high write enable
    input [15:0] write_data
);

reg [15:0] registers [0:31]; // 32 registers 16 bit each

always @ (posedge clk or posedge rst) begin : reg_block
    integer i;
    if(rst) begin
        for (i=0; i<32; i = i+1) begin
            registers[i] <= 16'h0000; // Reset all registers to 0
        end
    end else begin
        if (enw && (rd_add != 5'b00000)) begin
            registers[rd_add] <= write_data;
        end
    end
end


assign read1 = (rs_add1 == 5'b00000) ? 16'h0000 : registers[rs_add1]; // read port 1
assign read2 = (rs_add2 == 5'b00000) ? 16'h0000 : registers[rs_add2]; // read port 2

endmodule