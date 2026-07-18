/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o imm_gen_test ../tb/modules/tb_imm_gen.sv ../rtl/imm_gen.v"
 * Then: "vvp imm_gen_test"
 * Then: "gtkwave tb_imm_gen.vcd tb_imm_gen.gtkw" to view waveform
 */


`default_nettype none
`timescale 1ns/1ps


module tb_imm_gen;

    logic [31:0] instruction_in;
    logic [31:0] imm_gen_out;


    imm_gen dut (
        .instruction_in(instruction_in),
        .imm_gen_out(imm_gen_out)
    );


    initial begin

        //output files setup
        $dumpfile("tb_imm_gen.vcd");
        $dumpvars(0, tb_imm_gen);


        //clearing chip signals
        instruction_in = 32'd0;
        #20;


        $display("Starting Immediate Generator tests...");


        //test 1 I-type (lw) positive immediate
        //lw x1, 4(x0) -> Imm = +4 (12'h004)
        
        $display("Test 1: I-Type (lw) Positive Immediate");
        instruction_in = 32'h00402083; 
        #10;

        assert (imm_gen_out == 32'h00000004) begin
            $display("Test 1 passed");
        end 
        else begin
            $fatal(1, "Error: I-Type positive sign extension failed. Expected 00000004, got %h", imm_gen_out);
        end


        //test 2 I-type (lw) negative immediate
        //lw x1, -4(x0) -> Imm = -4 (12'hFFC)
        $display("Test 2: I-Type (lw) Negative Immediate");
        instruction_in = 32'hFFC02083; 
        #10;

        assert (imm_gen_out == 32'hFFFFFFFC) begin
            $display("Test 2 passed");
        end 
        else begin
            $fatal(1, "Error: I-Type negative sign extension failed. Expected FFFFFFFC, got %h", imm_gen_out);
        end


        //test 3 S-type (sw) positive immediate
        //sw x2, 8(x0) -> Imm = +8 (12'h008)
        $display("Test 3: S-Type (sw) Positive Immediate");
        instruction_in = 32'h00202423; 
        #10;

        assert (imm_gen_out == 32'h00000008) begin
            $display("Test 3 passed");
        end 
        else begin
            $fatal(1, "Error: S-Type positive split immediate failed. Expected 00000008, got %h", imm_gen_out);
        end


        //test 4 S-type (sw) negative immediate
        //sw x2, -8(x0) -> Imm = -8 (12'hFF8)
        $display("Test 4: S-Type (sw) Negative Immediate");
        instruction_in = 32'hFE202C23; 
        #10;

        assert (imm_gen_out == 32'hFFFFFFF8) begin
            $display("Test 4 passed");
        end 
        else begin
            $fatal(1, "Error: S-Type negative split immediate failed. Expected FFFFFFF8, got %h", imm_gen_out);
        end


        //test 5 B-type (beq) positive offset
        //beq x1, x2, +8 -> Imm = +8 (13'b0_0000_0000_1000)
        $display("Test 5: B-Type (beq) Positive Offset");
        instruction_in = 32'h00208463; 
        #10;

        assert (imm_gen_out == 32'h00000008) begin
            $display("Test 5 passed");
        end 
        else begin
            $fatal(1, "Error: B-Type positive scrambled immediate failed. Expected 00000008, got %h", imm_gen_out);
        end


        //test 6 B-type (beq) negative offset
        //beq x1, x2, -8 -> Imm = -8 (13'b1_1111_1111_1000)
        $display("Test 6: B-Type (beq) Negative Offset");
        instruction_in = 32'b1111_1110_0010_0000_1000_1100_1110_0011; 
        #10;

        assert (imm_gen_out == 32'hFFFFFFF8) begin
            $display("Test 6 passed");
        end 
        else begin
            $fatal(1, "Error: B-Type negative scrambled immediate failed. Expected FFFFFFF8, got %h", imm_gen_out);
        end


        //test 7: default case (unrecognized opcode / R-type)
        //add x3, x1, x2 -> No immediate generation should appear
        $display("Test 7: Default/R-Type Case (Zero Output Exception)");
        instruction_in = 32'h002081B3; 
        #10;

        assert (imm_gen_out == 32'h00000000) begin
            $display("Test 7 passed");
        end 
        else begin
            $fatal(1, "Error: Default case failed. Non-immediate instruction must return 00000000, got %h", imm_gen_out);
        end


        $display("All Immediate Generator tests successful, use 'gtkwave tb_imm_gen.vcd tb_imm_gen.gtkw' to open waveform.");
        
        $finish;

    end

endmodule
