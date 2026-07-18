/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o control_unit_test ../tb/modules/tb_control_unit.sv ../rtl/control_unit.v"
 * Then: "vvp control_unit_test"
 * Then: "gtkwave tb_control_unit.vcd tb_control_unit.gtkw" to view waveform
 */


`default_nettype none
`timescale 1ns/1ps


module tb_control_unit;

    logic [6:0] control_in;
    
    logic branch;
    logic mem_read;
    logic mem_to_reg;
    logic [1:0] alu_op;
    logic mem_write;
    logic alu_src;
    logic reg_write;


    control_unit dut (
        .control_in(control_in),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );


    initial begin

        //output files setup
        $dumpfile("tb_control_unit.vcd");
        $dumpvars(0, tb_control_unit);


        //clearing chip signals
        control_in = 7'b0000000;
        #20; 


        $display("All control signals concactenated in the order: branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write");
        $display("Starting Control Unit tests...");


        //test 1 R-type (add, sub, and, or)
        $display("Test 1: R-Type");
        control_in = 7'b0110011;
        #10;

        assert ({branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} == 8'b00010001) begin
            $display("Test 1 passed");
        end 
        else begin
            $fatal(1, "Error: R-Type failed. Expected 00010001, got %b", {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write});
        end


        //test 2 I-type (lw)
        $display("Test 2: I-Type");
        control_in = 7'b0000011;
        #10;

        assert ({branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} == 8'b01100011) begin
            $display("Test 2 passed");
        end 
        else begin
            $fatal(1, "Error: I-Type failed. Expected 01100011, got %b", {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write});
        end


        //test 3 S-type (sw)
        $display("Test 3: S-Type");
        control_in = 7'b0100011;
        #10;

        assert ({branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} == 8'b00000110) begin
            $display("Test 3 passed");
        end 
        else begin
            $fatal(1, "Error: S-Type failed. Expected 00000110, got %b", {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write});
        end


        //test 4 B-type (beq)
        $display("Test 4: B-Type");
        control_in = 7'b1100011;
        #10;

        assert ({branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} == 8'b10001000) begin
            $display("Test 4 passed");
        end 
        else begin
            $fatal(1, "Error: B-Type failed. Expected 10001000, got %b", {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write});
        end


        //test 5 unknown instruction fallback
        $display("Test 5: Unknown Instruction Fallback");
        control_in = 7'b1111111; 
        #10;

        assert ({branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} == 8'b00000000) begin
            $display("Test 5 passed");
        end 
        else begin
            $fatal(1, "Error: Fallback failed. Expected 00000000, got %b", {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write});
        end


        $display("All control unit tests successful, use 'gtkwave tb_control_unit.vcd tb_control_unit.gtkw' to open waveform.");
        
        $finish;

    end

endmodule
