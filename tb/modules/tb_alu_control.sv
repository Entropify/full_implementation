/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o alu_control_test ../tb/modules/tb_alu_control.sv ../rtl/alu_control.v"
 * Then: "vvp alu_control_test"
 * Then: "gtkwave tb_alu_control.vcd tb_alu_control.gtkw" to view waveform
 */


`default_nettype none
`timescale 1ns/1ps


module tb_alu_control;

    logic [1:0] alu_op;
    logic func7;
    logic [2:0] func3;
    
    logic [3:0] alu_control_out;


    alu_control dut (
        .alu_op(alu_op),
        .func7(func7),
        .func3(func3),
        .alu_control_out(alu_control_out)
    );


    initial begin

        //output files setup
        $dumpfile("tb_alu_control.vcd");
        $dumpvars(0, tb_alu_control);


        //clearing chip signals
        alu_op = 2'b00;
        func7 = 1'b0;
        func3 = 3'b000;
        #20; 


        $display("Starting ALU Control tests...");


        //test 1 I/S-type address calculation
        $display("Test 1: I/S-Type Address Calculation");
        alu_op = 2'b00;
        func7  = 1'b1;
        func3  = 3'b111;
        #10;

        assert (alu_control_out == 4'b0010) begin
            $display("Test 1 passed");
        end 
        else begin
            $fatal(1, "Error: I/S-Type failed. Expected 0010, got %b", alu_control_out);
        end


        //test 2 B-type (beq) comparison
        $display("Test 2: B-Type (beq) Comparison");
        alu_op = 2'b01;
        func7  = 1'b0;
        func3  = 3'b000;
        #10;

        assert (alu_control_out == 4'b0110) begin
            $display("Test 2 passed");
        end 
        else begin
            $fatal(1, "Error: B-Type failed. Expected 0110, got %b", alu_control_out);
        end


        //test 3 R-type add
        $display("Test 3: R-Type ADD");
        alu_op = 2'b10;
        func3  = 3'b000;
        func7  = 1'b0;
        #10;

        assert (alu_control_out == 4'b0010) begin
            $display("Test 3 passed");
        end 
        else begin
            $fatal(1, "Error: R-Type ADD failed. Expected 0010, got %b", alu_control_out);
        end


        //test 4 R-type sub
        $display("Test 4: R-Type SUB");
        alu_op = 2'b10;
        func3  = 3'b000;
        func7  = 1'b1;
        #10;

        assert (alu_control_out == 4'b0110) begin
            $display("Test 4 passed");
        end 
        else begin
            $fatal(1, "Error: R-Type SUB failed. Expected 0110, got %b", alu_control_out);
        end


        //test 5 R-type and
        $display("Test 5: R-Type AND");
        alu_op = 2'b10;
        func3  = 3'b111;
        func7  = 1'b0;
        #10;

        assert (alu_control_out == 4'b0000) begin
            $display("Test 5 passed");
        end 
        else begin
            $fatal(1, "Error: R-Type AND failed. Expected 0000, got %b", alu_control_out);
        end


        //test 6 R-type or
        $display("Test 6: R-Type OR");
        alu_op = 2'b10;
        func3  = 3'b110;
        func7  = 1'b0;
        #10;

        assert (alu_control_out == 4'b0001) begin
            $display("Test 6 passed");
        end 
        else begin
            $fatal(1, "Error: R-Type OR failed. Expected 0001, got %b", alu_control_out);
        end


        //test 7 R-type unknown safety fallback
        $display("Test 7: R-Type Unknown Safety Fallback");
        alu_op = 2'b10;
        func3  = 3'b011; 
        func7  = 1'b0;
        #10;

        assert (alu_control_out == 4'b0000) begin
            $display("Test 7 passed");
        end 
        else begin
            $fatal(1, "Error: R-Type safety fallback failed. Expected 0000, got %b", alu_control_out);
        end


        //test 8 main alu_op unknown safety fallback
        $display("Test 8: Main ALU_OP Safety Fallback");
        alu_op = 2'b11; 
        func3  = 3'b000;
        func7  = 1'b0;
        #10;

        assert (alu_control_out == 4'b0000) begin
            $display("Test 8 passed");
        end 
        else begin
            $fatal(1, "Error: Main safety fallback failed. Expected 0000, got %b", alu_control_out);
        end


        $display("All ALU Control tests successful, use 'gtkwave tb_alu_control.vcd tb_alu_control.gtkw' to open waveform.");
        
        $finish;

    end

endmodule
