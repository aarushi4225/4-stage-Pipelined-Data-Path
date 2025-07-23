`timescale 1ns / 1ps

module datapath_tb;

    // Testbench inputs
    reg master_clk;
    reg main_rst;

    reg [4:0] tb_rs1_addr;
    reg [4:0] tb_rs2_addr;
    reg [4:0] tb_rd_addr_wb;
    reg tb_reg_write_en_wb;

    reg [3:0] tb_alu_sel; 

    reg [7:0] tb_mem_access_addr;
    reg tb_mem_write_en;
    reg tb_mem_read_en; 
    reg [15:0] tb_mem_write_data;

    reg tb_wb_data_sel;

    // Testbench outputs
    wire [15:0] debug_rf_read1_out;
    wire [15:0] debug_rf_read2_out;
    wire [15:0] debug_alu_result;
    wire [15:0] debug_mem_read_data;

    //Datapath DUT 
    datapath dut (
        .main_clk           (master_clk),
        .main_rst           (main_rst),

        .tb_rs1_addr        (tb_rs1_addr),
        .tb_rs2_addr        (tb_rs2_addr),
        .tb_rd_addr_wb      (tb_rd_addr_wb),
        .tb_reg_write_en_wb (tb_reg_write_en_wb),

        .tb_alu_sel         (tb_alu_sel),

        .tb_mem_access_addr (tb_mem_access_addr),
        .tb_mem_write_en    (tb_mem_write_en),
        .tb_mem_read_en     (tb_mem_read_en),
        .tb_mem_write_data  (tb_mem_write_data),

        .tb_wb_data_sel     (tb_wb_data_sel),

        .debug_rf_read1_out (debug_rf_read1_out),
        .debug_rf_read2_out (debug_rf_read2_out),
        .debug_alu_result   (debug_alu_result),
        .debug_mem_read_data(debug_mem_read_data)
    );

    
    initial begin
        master_clk = 0;
        forever #5 master_clk = ~master_clk;
    end

    
    initial begin
        // State for all signals
        main_rst            = 1; 
        tb_rs1_addr         = 5'b0;
        tb_rs2_addr         = 5'b0;
        tb_rd_addr_wb       = 5'b0;
        tb_reg_write_en_wb  = 0;
        tb_alu_sel          = 4'b0000;
        tb_mem_access_addr  = 8'h00;
        tb_mem_write_en     = 0;
        tb_mem_read_en      = 0;
        tb_mem_write_data   = 16'h0000;
        tb_wb_data_sel      = 0; 

       
        // Holding reset to clear everything
        #10;
        main_rst = 1;
        $display("Time=%0t: Asserting Reset", $time);
        @(posedge master_clk); // master_clk positive edge while reset is high
        @(posedge master_clk); //second full clock cycle
        @(posedge master_clk); //third full clock cycle

        main_rst = 0; // to off the reset
        $display("Time=%0t: --- Deasserting Reset. Pipeline and Memory cleared. ---", $time);

        // --- Pipelining Started ---
        
        // 1. Pipelined : Inst 1 enters IF/RF
        @(posedge master_clk);
        $display("Time=%0t: [CC1] Setting up ALU_ADD R4 = R0 + R0.", $time);
        tb_rs1_addr         = 5'd0;    
        tb_rs2_addr         = 5'd0;    
        tb_alu_sel          = 4'b0000;
        tb_rd_addr_wb       = 5'd4; 
        tb_reg_write_en_wb  = 1; 
        tb_wb_data_sel      = 0;  
        tb_mem_access_addr  = 8'h00;
        tb_mem_write_en     = 0;
        tb_mem_read_en      = 0;
        tb_mem_write_data   = 16'h0000;

        // 2. Pipelined: While Inst1 is in EX, Inst2 enters IF/RF
        @(posedge master_clk);
        $display("Time=%0t: [CC2] Setting up ALU_ADD R5 = R0 + R0. Inst1 in EX.", $time);
        tb_rs1_addr         = 5'd0;   
        tb_rs2_addr         = 5'd0;    
        tb_alu_sel          = 4'b0000;
        tb_rd_addr_wb       = 5'd5;   
        tb_reg_write_en_wb  = 1;
        tb_wb_data_sel      = 0;

        // 3. Pipelined: While Inst2 in EX, Inst1 in MEM, Inst3 enters IF/RF
        @(posedge master_clk);
        $display("Time=%0t: [CC3] Setting up MEM_STORE Mem[0x10] = 0xCAFE. Inst1 in MEM, Inst2 in EX.", $time);
        tb_rs1_addr         = 5'd0;    
        tb_rs2_addr         = 5'd0;    
        tb_alu_sel          = 4'b0000; 
        tb_rd_addr_wb       = 5'd0; 
        tb_reg_write_en_wb  = 0;
        tb_wb_data_sel      = 0;     
        tb_mem_access_addr  = 8'h10;   
        tb_mem_write_en     = 1;      
        tb_mem_read_en      = 0;       
        tb_mem_write_data   = 16'hCAFE; 
        
        
        // 4. Pipelined: While Inst3 in EX, Inst2 in MEM, Inst1 in WB, Inst4 enters IF/RF
        @(posedge master_clk);
        $display("Time=%0t: [CC4] Setting up MEM_LOAD R6 = Mem[0x10]. Inst1 in WB, Inst2 in MEM, Inst3 in EX.", $time);
        tb_rs1_addr         = 5'd0;    
        tb_rs2_addr         = 5'd0;   
        tb_alu_sel          = 4'b0000;
        tb_rd_addr_wb       = 5'd6;   
        tb_reg_write_en_wb  = 1;       
        tb_wb_data_sel      = 1;       
        tb_mem_access_addr  = 8'h10;  
        tb_mem_write_en     = 0;       
        tb_mem_read_en      = 1;       
        tb_mem_write_data   = 16'h0000;


        // 5. Pipelined: While Inst4 in EX, Inst3 in MEM, Inst2 in WB, Inst5 enters IF/RF
        @(posedge master_clk);
        $display("Time=%0t: [CC5] Setting up ALU_ADD R7 = R0 + 0x0001. Inst2 in WB, Inst3 in MEM, Inst4 in EX.", $time);
        tb_rs1_addr         = 5'd0;    
        tb_rs2_addr         = 5'd0;   
        tb_alu_sel          = 4'b0000; 
        tb_rd_addr_wb       = 5'd7; 
        tb_reg_write_en_wb  = 1;
        tb_wb_data_sel      = 0;
        tb_mem_access_addr  = 8'h00;
        tb_mem_write_en     = 0;
        tb_mem_read_en      = 0;
        tb_mem_write_data   = 16'h0001;
        $display("Time=%0t: Adjusting Inst5 to R7 = R0 + R0 for simpler test.", $time);
        tb_mem_write_data   = 16'h0000; 
        
        @(posedge master_clk); // CC6
        
        $display("Time=%0t: [CC6] Inst3 in WB, Inst4 in MEM, Inst5 in EX.", $time);
        
        tb_rs1_addr = 5'd4; 
        tb_rs2_addr = 5'd0;
        tb_reg_write_en_wb = 0; 
        tb_wb_data_sel = 0; 
        tb_alu_sel = 4'b0000;

        @(posedge master_clk); // CC7
        
        $display("Time=%0t: [CC7] Inst4 in WB, Inst5 in MEM. R4 (expected 0) : %h", $time, debug_rf_read1_out);
       
       
        tb_rs1_addr = 5'd5; // Read R5 as it is completed now
        tb_rs2_addr = 5'd0;
        tb_reg_write_en_wb = 0;
        tb_wb_data_sel = 0;
        tb_alu_sel = 4'b0000;

        @(posedge master_clk); // CC8
        
        $display("Time=%0t: [CC8] Inst5 in WB. R5 (expected 0) : %h", $time, debug_rf_read1_out);
       
        tb_rs1_addr = 5'd6; // Read R6 its also completed
        tb_rs2_addr = 5'd0;
        tb_reg_write_en_wb = 0;
        tb_wb_data_sel = 0;
        tb_alu_sel = 4'b0000;

        @(posedge master_clk); // CC9
        
        $display("Time=%0t: [CC9] Pipelined operations draining. R6 (expected CAFE) : %h", $time, debug_rf_read1_out);
       
        tb_rs1_addr = 5'd7; // Read R7 it is completed
        tb_rs2_addr = 5'd0;
        tb_reg_write_en_wb = 0;
        tb_wb_data_sel = 0;
        tb_alu_sel = 4'b0000;

        @(posedge master_clk); // 
        
        $display("Time=%0t: [CC10] Final check. R7 (expected 0) : %h", $time, debug_rf_read1_out);


        // Closing
        $display("Time=%0t: Simulation complete.", $time);
        #20;
        $finish; // End simulation
    end

    //Clear space by dumpfiles
    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);
        $dumpvars(0, datapath_tb.dut);
        $dumpvars(0, datapath_tb.dut.i_reg_file);
        $dumpvars(0, datapath_tb.dut.i_data_mem);
    end

endmodule