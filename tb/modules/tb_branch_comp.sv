/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o branch_comp_test ../tb/modules/tb_branch_comp.sv ../rtl/branch_comp.v"
 * Then: "vvp branch_comp_test"
 * Then: "gtkwave tb_branch_comp.vcd tb_branch_comp.gtkw" to view waveform
 */



`default_nettype none
`timescale 1ns/1ps

module tb_branch_comp;

    logic [31:0] data_1;
    logic [31:0] data_2;
    logic [2:0]  func_3;
    
    logic take_branch;

    branch_comp dut (
        .data_1(data_1),
        .data_2(data_2),
        .func_3(func_3),
        .take_branch(take_branch)
    );

    initial begin
        $dumpfile("tb_branch_comp.vcd");
        $dumpvars(0, tb_branch_comp);

        data_1 = 32'd0;
        data_2 = 32'd0;
        func_3 = 3'd0;
        #20;

        $display("Starting Branch Comparator tests...");

        // beq
        func_3 = 3'b000; 
        data_1 = 32'd10; 
        data_2 = 32'd10; 
        #10;
        assert(take_branch == 1'b1) $display("Test 1 passed");
            
        else $fatal(1, "BEQ True failed");
        
        func_3 = 3'b000; 
        data_1 = 32'd10; 
        data_2 = 32'd20; 
        #10;
        assert(take_branch == 1'b0) $display("Test 2 passed");
            
        else $fatal(1, "BEQ False failed");

        // bne
        func_3 = 3'b001; 
        data_1 = 32'd10; 
        data_2 = 32'd20; 
        #10;
        assert(take_branch == 1'b1) $display("Test 3 passed");
            
        else $fatal(1, "BNE True failed");

        // blt (signed -1 < 5)
        func_3 = 3'b100; 
        data_1 = 32'hFFFFFFFF; 
        data_2 = 32'd5; 
        #10;
        assert(take_branch == 1'b1) $display("Test 4 passed");
            
        else $fatal(1, "BLT True failed");

        // bge (signed 5 >= -1)
        func_3 = 3'b101; 
        data_1 = 32'd5; 
        data_2 = 32'hFFFFFFFF; 
        #10;
        assert(take_branch == 1'b1) $display("Test 5 passed");
            
        else $fatal(1, "BGE True failed");

        // bltu (unsigned 0xFFFFFFFF < 5)
        func_3 = 3'b110; 
        data_1 = 32'hFFFFFFFF; 
        data_2 = 32'd5; 
        #10;
        assert(take_branch == 1'b0) $display("Test 6 passed");
            
        else $fatal(1, "BLTU False failed");

        // bgeu (unsigned 0xFFFFFFFF >= 5)
        func_3 = 3'b111; 
        data_1 = 32'hFFFFFFFF;
        data_2 = 32'd5; 
        #10;
        assert(take_branch == 1'b1) $display("Test 7 passed");
            
        else $fatal(1, "BGEU True failed");

        // Default fallback (invalid func3)
        func_3 = 3'b010; 
        data_1 = 32'd0; 
        data_2 = 32'd0; 
        #10;
        assert(take_branch == 1'b0) $display("Test 8 passed");
            
        else $fatal(1, "Default fallback failed");

        $display("All Branch Comparator tests successful, use 'gtkwave tb_branch_comp.vcd tb_branch_comp.gtkw' to open waveform.");
        
        $finish;

    end

endmodule
