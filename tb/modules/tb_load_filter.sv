/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o load_filter_test ../tb/modules/tb_load_filter.sv ../rtl/load_filter.v"
 * Then: "vvp load_filter_test"
 * Then: "gtkwave tb_load_filter.vcd tb_load_filter.gtkw" to view waveform
 */

`default_nettype none
`timescale 1ns/1ps

module tb_load_filter;

    logic [2:0]  func3;
    logic [31:0] ram_data;
    logic [1:0]  byte_offset;

    logic [31:0] filtered_data;

    load_filter dut (
        .func3(func3),
        .ram_data(ram_data),
        .byte_offset(byte_offset),
        .filtered_data(filtered_data)
    );

    initial begin
        // output files setup
        $dumpfile("tb_load_filter.vcd");
        $dumpvars(0, tb_load_filter);

        // clearing chip signals
        func3 = 3'd0;
        ram_data = 32'd0;
        byte_offset = 2'd0;
        #20;

        $display("Starting Load Filter tests...");

        // test 1: lw
        $display("Test 1: Load Word (LW)");
        func3 = 3'b010;
        byte_offset = 2'b00;
        ram_data = 32'h89ABCDEF;
        #10;
        assert(filtered_data == 32'h89ABCDEF) begin
            $display("Test 1 passed");
        end else begin
            $fatal(1, "Error: LW failed. Expected 89ABCDEF, got %h", filtered_data);
        end

        // test 2: lbu offset 1
        $display("Test 2: Load Byte Unsigned (LBU) Offset 1");
        func3 = 3'b100;
        byte_offset = 2'b01;
        ram_data = 32'h89ABCDEF; // byte 1 is CD
        #10;
        assert(filtered_data == 32'h000000CD) begin
            $display("Test 2 passed");
        end else begin
            $fatal(1, "Error: LBU Offset 1 failed. Expected 000000CD, got %h", filtered_data);
        end

        // test 3: lb offset 3
        $display("Test 3: Load Byte (LB) Negative Offset 3");
        func3 = 3'b000;
        byte_offset = 2'b11;
        ram_data = 32'h89ABCDEF; // msb 1
        #10;
        assert(filtered_data == 32'hFFFFFF89) begin
            $display("Test 3 passed");
        end else begin
            $fatal(1, "Error: LB Negative Offset 3 failed. Expected FFFFFF89, got %h", filtered_data);
        end

        // test 4: lb offset 0
        $display("Test 4: Load Byte (LB) Positive Offset 0");
        func3 = 3'b000;
        byte_offset = 2'b00;
        ram_data = 32'h89ABCD7F; // msb 0
        #10;
        assert(filtered_data == 32'h0000007F) begin
            $display("Test 4 passed");
        end else begin
            $fatal(1, "Error: LB Positive Offset 0 failed. Expected 0000007F, got %h", filtered_data);
        end

        // test 5: lhu offset 2
        $display("Test 5: Load Halfword Unsigned (LHU) Offset 2");
        func3 = 3'b101;
        byte_offset = 2'b10;
        ram_data = 32'h89ABCDEF;
        #10;
        assert(filtered_data == 32'h000089AB) begin
            $display("Test 5 passed");
        end else begin
            $fatal(1, "Error: LHU Offset 2 failed. Expected 000089AB, got %h", filtered_data);
        end

        // test 6: lh negative offset 2
        $display("Test 6: Load Halfword (LH) Negative Offset 2");
        func3 = 3'b001; 
        byte_offset = 2'b10;
        ram_data = 32'h89ABCDEF; // msb is 1
        #10;
        assert(filtered_data == 32'hFFFF89AB) begin
            $display("Test 6 passed");
        end else begin
            $fatal(1, "Error: LH Negative Offset 2 failed. Expected FFFF89AB, got %h", filtered_data);
        end
        
        // test 7: default
        $display("Test 7: Default Opcode Fallback");
        func3 = 3'b111;
        byte_offset = 2'b00;
        ram_data = 32'hFFFFFFFF; 
        #10;
        assert(filtered_data == 32'h00000000) begin
            $display("Test 7 passed");
        end else begin
            $fatal(1, "Error: Default fallback failed. Expected 00000000, got %h", filtered_data);
        end

        $display("All Load Filter tests successful, use 'gtkwave tb_load_filter.vcd tb_load_filter.gtkw' to open waveform.");
        
        $finish;

    end

endmodule
