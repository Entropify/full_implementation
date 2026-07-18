/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module soc_top (
    input wire clk,
    input wire rst_n
);


// instr mem bus

wire [31:0] instr_address;
wire [31:0] instruction;


// data mem bus

wire [31:0] data_address;
wire [31:0] data_write;
wire [31:0] data_read;
wire        mem_write;
wire        mem_read;

// rv32i cpu

rv32i_core cpu (
    .clk(clk),
    .rst_n(rst_n),

    .instr_address(instr_address),
    .instruction(instruction),

    .data_address(data_address),
    .data_write(data_write),
    .data_read(data_read),
    .mem_write(mem_write),
    .mem_read(mem_read)
    );


// instr mem

instruction_mem rom (
        .address(instr_address),
        .instruction(instruction)
    );


// data mem

    data_mem ram (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(data_address),
        .write_data(data_write),
        .read_data(data_read)
    );
    
endmodule
