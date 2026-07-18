/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


 module data_mem (
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
 );

reg [31:0] mem_array [0:1023];

always @(posedge clk) begin

    if (mem_write) begin
        mem_array[address[31:2]] <= write_data;

    end
end

assign read_data = (mem_read) ? mem_array[address[31:2]] : 32'b0;

 endmodule
 