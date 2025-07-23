`timescale 1ns / 1ps

module datapath (
    input wire main_clk,
    input wire main_rst,

    input wire [4:0] tb_rs1_addr,
    input wire [4:0] tb_rs2_addr,
    input wire [4:0] tb_rd_addr_wb,
    input wire tb_reg_write_en_wb,

    input wire [3:0] tb_alu_sel,

    input wire [7:0] tb_mem_access_addr,
    input wire tb_mem_write_en,
    input wire tb_mem_read_en,
    input wire [15:0] tb_mem_write_data,

    input wire tb_wb_data_sel,

    output wire [15:0] debug_rf_read1_out,
    output wire [15:0] debug_rf_read2_out,
    output wire [15:0] debug_alu_result,
    output wire [15:0] debug_mem_read_data
);

    wire phi1_clk;
    wire phi2_clk;

    wire [15:0] rf_read_data1_out;
    wire [15:0] rf_read_data2_out;
    wire [15:0] alu_Z_out;
    wire [15:0] mem_read_data_out;

    reg [15:0] pr1_operand1_ex;
    reg [15:0] pr1_operand2_ex;
    reg [3:0]  pr1_alu_sel_ex;
    reg [4:0]  pr1_rd_addr_wb_ex;
    reg        pr1_reg_write_en_wb_ex;
    reg [7:0]  pr1_mem_access_addr_ex;
    reg [15:0] pr1_mem_write_data_ex;
    reg        pr1_mem_write_en_ex;
    reg        pr1_mem_read_en_ex;
    reg        pr1_wb_data_sel_ex;

    reg [15:0] pr2_alu_result_mem;
    reg [7:0]  pr2_mem_access_addr_mem;
    reg [15:0] pr2_mem_write_data_mem;
    reg        pr2_mem_write_en_mem;
    reg        pr2_mem_read_en_mem;
    reg [4:0]  pr2_rd_addr_wb_mem;
    reg        pr2_reg_write_en_wb_mem;
    reg        pr2_wb_data_sel_mem;

    reg [15:0] pr3_mem_read_data_wb;
    reg [15:0] pr3_alu_result_wb;
    reg [4:0]  pr3_rd_addr_wb_final;
    reg        pr3_reg_write_en_wb_final;
    reg        pr3_wb_data_sel_final;


    clk2phase i_clk_gen (
        .master(main_clk),
//        .master(main_rst),
        .phi1(phi1_clk),
        .phi2(phi2_clk)
    );

    wire [15:0] write_back_data;

    register_file i_reg_file (
        .clk        (main_clk),
        .rst        (main_rst),
        .rs_add1    (tb_rs1_addr),
        .rs_add2    (tb_rs2_addr),
        .read1      (rf_read_data1_out),
        .read2      (rf_read_data2_out),
        .rd_add     (pr3_rd_addr_wb_final),
        .enw        (pr3_reg_write_en_wb_final),
        .write_data (write_back_data)
    );

    // IF/RF Stage 
    always @(posedge phi1_clk or posedge main_rst) begin
        if (main_rst) begin
            pr1_operand1_ex        <= 16'h0000;
            pr1_operand2_ex        <= 16'h0000;
            pr1_alu_sel_ex         <= 4'b0000; 
            pr1_rd_addr_wb_ex      <= 5'b00000;
            pr1_reg_write_en_wb_ex <= 1'b0;
            pr1_mem_access_addr_ex <= 8'h00;
            pr1_mem_write_data_ex  <= 16'h0000;
            pr1_mem_write_en_ex    <= 1'b0;
            pr1_mem_read_en_ex     <= 1'b0;
            pr1_wb_data_sel_ex     <= 1'b0;
        end else begin
            pr1_operand1_ex        <= rf_read_data1_out;
            pr1_operand2_ex        <= rf_read_data2_out;
            pr1_alu_sel_ex         <= tb_alu_sel;
            pr1_rd_addr_wb_ex      <= tb_rd_addr_wb;
            pr1_reg_write_en_wb_ex <= tb_reg_write_en_wb;
            pr1_mem_access_addr_ex <= tb_mem_access_addr;
            pr1_mem_write_data_ex  <= tb_mem_write_data;
            pr1_mem_write_en_ex    <= tb_mem_write_en;
            pr1_mem_read_en_ex     <= tb_mem_read_en;
            pr1_wb_data_sel_ex     <= tb_wb_data_sel;
        end
    end

    // EX Stage
    alu i_alu (
        .A           (pr1_operand1_ex),
        .B           (pr1_operand2_ex),
        .sel         (pr1_alu_sel_ex),
        .Z           (alu_Z_out),
        .clk         (phi2_clk),
        .rst         (main_rst)
    );

    // MEM Stage
    always @(posedge phi2_clk or posedge main_rst) begin
        if (main_rst) begin
            pr2_alu_result_mem     <= 16'h0000;
            pr2_mem_access_addr_mem<= 8'h00;
            pr2_mem_write_data_mem <= 16'h0000;
            pr2_mem_write_en_mem   <= 1'b0;
            pr2_mem_read_en_mem    <= 1'b0;
            pr2_rd_addr_wb_mem     <= 5'b00000;
            pr2_reg_write_en_wb_mem<= 1'b0;
            pr2_wb_data_sel_mem    <= 1'b0;
        end else begin
            pr2_alu_result_mem     <= alu_Z_out;
            pr2_mem_access_addr_mem<= pr1_mem_access_addr_ex;
            pr2_mem_write_data_mem <= pr1_mem_write_data_ex;
            pr2_mem_write_en_mem   <= pr1_mem_write_en_ex;
            pr2_mem_read_en_mem    <= pr1_mem_read_en_ex;
            pr2_rd_addr_wb_mem     <= pr1_rd_addr_wb_ex;
            pr2_reg_write_en_wb_mem<= pr1_reg_write_en_wb_ex;
            pr2_wb_data_sel_mem    <= pr1_wb_data_sel_ex;
        end
    end

    memory i_data_mem (
        .clk        (main_clk),
        .rst        (main_rst),
        .wt_en      (pr2_mem_write_en_mem),
        .data_wt    (pr2_mem_write_data_mem),
        .wt_addr    (pr2_mem_access_addr_mem),
        .rd_addr    (pr2_mem_access_addr_mem),
        .read_out   (mem_read_data_out)
    );

    // WB Stage 
    always @(posedge phi1_clk or posedge main_rst) begin
        if (main_rst) begin
            pr3_mem_read_data_wb      <= 16'h0000;
            pr3_alu_result_wb         <= 16'h0000;
            pr3_rd_addr_wb_final      <= 5'b00000;
            pr3_reg_write_en_wb_final <= 1'b0;
            pr3_wb_data_sel_final     <= 1'b0;
        end else begin
            pr3_mem_read_data_wb      <= mem_read_data_out;
            pr3_alu_result_wb         <= pr2_alu_result_mem;
            pr3_rd_addr_wb_final      <= pr2_rd_addr_wb_mem;
            pr3_reg_write_en_wb_final <= pr2_reg_write_en_wb_mem;
            pr3_wb_data_sel_final     <= pr2_wb_data_sel_mem;
        end
    end

    // Write-back MUX
    assign write_back_data = (pr3_wb_data_sel_final == 1'b1) ? pr3_mem_read_data_wb : pr3_alu_result_wb;

    // Debug Outputs
    assign debug_rf_read1_out  = rf_read_data1_out;
    assign debug_rf_read2_out  = rf_read_data2_out;
    assign debug_alu_result    = alu_Z_out;
    assign debug_mem_read_data = mem_read_data_out;

endmodule