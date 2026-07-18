/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o alu_test ../tb/modules/tb_alu.sv ../rtl/alu.v"
 * Then: "vvp alu_test"
 * Then: "gtkwave tb_alu.vcd tb_alu.gtkw" to view waveform
 */


`default_nettype none
`timescale 1ns/1ps

 
 module tb_alu;

    logic [31:0] tb_data_1;
    logic [31:0] tb_data_2;
    logic [3:0]  tb_alu_control;

    logic [31:0] tb_alu_result;
    logic        tb_zero;

    alu dut (
        .data_1(tb_data_1),
        .data_2(tb_data_2),
        .alu_control(tb_alu_control),
        .alu_result(tb_alu_result),
        .zero(tb_zero)
    );

    initial begin

        //output files setup

        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_alu);

        //clearing chip signals

        tb_data_1 = 32'd0;
        tb_data_2 = 32'd0;
        tb_alu_control = 4'b0000;
        
        #10;

        $display("Starting ALU tests...");


        //test 1 ADD 15 + 25 = 40

        tb_data_1 = 32'd15;
        tb_data_2 = 32'd25; 
        tb_alu_control = 4'b0010;
        
        #10;

        $display("Test 1 (ADD): 15 + 25 = 40");

        assert (tb_alu_result == 32'd40) begin
            $display("Test 1 passed");
        end 

        else begin
            $fatal (1, "Error: ALU autput is wrong. Expected 15 + 25 = 40, got %d", tb_alu_result);
        end
        


        //test 2 SUB 100 - 100 = 0

        tb_data_1 = 32'd100;
        tb_data_2 = 32'd100;
        tb_alu_control = 4'b0110;
        
        #10;

        $display("Test 2 (SUB): 100 - 100 = 0");

        assert (tb_alu_result == 32'd0) begin
            $display("Test 2 output passed");
        end 

        else begin
            $fatal (1, "Error: ALU autput is wrong. Expected 100 - 100 = 0, got %d", tb_alu_result);
        end

        assert (tb_zero == 1'b1) begin
            $display("Test 2 zero flag passed");  
        end 

        else begin
            $fatal (1, "Error: Zero flag is wrong. Expected zero flag of 1 when 100 - 100 = 0, got %b", tb_zero);
        end

        $display("Test 2 passed");



        //test 3 AND 1100 & 1010 = 1000

        tb_data_1 = 32'b1100;
        tb_data_2 = 32'b1010;
        tb_alu_control = 4'b0000;
        
        #10;

        $display("Test 3 (AND): 1100 & 1010 = 1000");

        assert (tb_alu_result == 32'b1000) begin
            $display("Test 3 passed");
        end 

        else begin
            $fatal (1, "Error: ALU autput is wrong. Expected 1100 & 1010 = 1000, got %b", tb_alu_result);
        end



        //test 4 OR 1001 | 0110 = 1111

        tb_data_1 = 32'b1001;
        tb_data_2 = 32'b0110;
        tb_alu_control = 4'b0001;
        
        #10;

        $display("Test 4 (OR): 1001 | 0110 = 1111");

        assert (tb_alu_result == 32'b1111) begin
            $display("Test 4 passed");
        end 

        else begin
            $fatal (1, "Error: ALU autput is wrong. Expected 1001 | 0110 = 1111, got %b", tb_alu_result);
        end


        //test 5 invalid control signal 1111

        tb_data_1 = 32'b1000;
        tb_data_2 = 32'b1110;
        tb_alu_control = 4'b1111;

        #10;

        $display("Test 5 (invalid control signal): 1111");

        assert (tb_alu_result == 32'h0000_0000) begin
            $display("Test 5 passed");
        end 

        else begin
            $fatal (1, "Error: ALU autput is wrong. Expected output 32'h0000_0000 for invalid control signal 1111, got %b", tb_alu_result);
        end


        $display("All ALU tests successful, use 'gtkwave tb_alu.vcd tb_alu.gtkw' to open waveform.");

        
        $finish;

    end

endmodule
