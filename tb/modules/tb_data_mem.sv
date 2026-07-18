/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 *
 *
 * cd into sim first, then run wsl, then run the following:
 * "iverilog -g2012 -o data_mem_test ../tb/modules/tb_data_mem.sv ../rtl/data_mem.v"
 * Then: "vvp data_mem_test"
 * Then: "gtkwave tb_data_mem.vcd tb_data_mem.gtkw" to view waveform
 */


`default_nettype none
`timescale 1ns/1ps


module tb_data_mem;

    logic clk;
    logic mem_write;
    logic mem_read;
    logic [31:0] address;
    logic [31:0] write_data;
    
    logic [31:0] read_data;


    data_mem dut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );


    //clk
    initial clk = 0;
    always #5 clk = ~clk; 


    initial begin

        //output files setup
        $dumpfile("tb_data_mem.vcd");
        $dumpvars(0, tb_data_mem);


        //clearing chip signals
        mem_write = 1'b0;
        mem_read = 1'b0;
        address = 32'd0;
        write_data = 32'd0;
        #20; 


        $display("Starting Data Memory tests...");


        //test 1 basic write and read
        $display("Test 1: Basic Write and Read (Address 4)");
        address = 32'd4;
        write_data = 32'hDEADBEEF;
        mem_write = 1'b1;
        
        @(posedge clk);
        #1;
        mem_write = 1'b0;

        address = 32'd4;
        mem_read = 1'b1;
        #1;

        assert (read_data == 32'hDEADBEEF) begin
            $display("Test 1 passed");
        end 
        else begin
            $fatal(1, "Error: Write/Read failed. Expected DEADBEEF, got %h", read_data);
        end


        //test 2 mem_read disable test
        $display("Test 2: Memory Read Disable");
        mem_read = 1'b0;
        #1;

        assert (read_data == 32'h00000000) begin
            $display("Test 2 passed");
        end 
        else begin
            $fatal(1, "Error: mem_read disable failed. Expected 00000000, got %h", read_data);
        end


        //test 3 write isolation check
        $display("Test 3: Write Isolation Check (Address 8 vs 4)");
        //write to address 8
        address = 32'd8;
        write_data = 32'hDAD69420;
        mem_write = 1'b1;
        
        @(posedge clk);
        #1;
        mem_write = 1'b0;

        //read back address 4 to ensure it wasn't overwritten
        address = 32'd4;
        mem_read = 1'b1;
        #1;

        assert (read_data == 32'hDEADBEEF) begin
            $display("Test 3 passed");
        end 
        else begin
            $fatal(1, "Error: Memory corrupted! Address 4 was overwritten. Got %h", read_data);
        end


        //test 4 word alignment check [31:2]
        $display("Test 4: Word Alignment Check");
        //write to address 12
        address = 32'd12;
        write_data = 32'h12345678;
        mem_write = 1'b1;
        mem_read = 1'b0;
        
        @(posedge clk);
        #1;
        mem_write = 1'b0;

        //try reading from address 15 (should map to the exact same word as 12)
        address = 32'd15;
        mem_read = 1'b1;
        #1;

        assert (read_data == 32'h12345678) begin
            $display("Test 4 passed");
        end 
        else begin
            $fatal(1, "Error: Word alignment [31:2] failed. Expected 12345678, got %h", read_data);
        end


        $display("All Data Memory tests successful, use 'gtkwave tb_data_mem.vcd tb_data_mem.gtkw' to open waveform.");
        
        $finish;

    end

endmodule
