/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

 module control_unit (
    input wire [6:0] control_in,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write
 );

 always @(*) begin

    case (control_in)

    7'b0110011: begin // R-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 2'b10;
        mem_write = 1'b0;
        alu_src = 1'b0;
        reg_write = 1'b1;
    end

    7'b0000011: begin // I-type (lw)
        branch = 1'b0; 
        mem_read = 1'b1;
        mem_to_reg = 1'b1;
        alu_op = 2'b00;
        mem_write = 1'b0;
        alu_src = 1'b1;
        reg_write = 1'b1;
    end

    7'b0100011: begin // S-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 2'b00;
        mem_write = 1'b1;
        alu_src = 1'b1;
        reg_write = 1'b0;
    end

    7'b1100011: begin // B-type
        branch = 1'b1; 
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 2'b01;
        mem_write = 1'b0;
        alu_src = 1'b0;
        reg_write = 1'b0;
    end

    7'b0010011: begin // I-type (alu math)
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 2'b11; // remember ts gng </3
        mem_write = 1'b0;
        alu_src = 1'b1;
        reg_write = 1'b1;
    end

    default: begin // safety for unknown instruction type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 2'b00; 
        mem_write = 1'b0;
        alu_src = 1'b0;
        reg_write = 1'b0;
    end

    endcase

 end


 endmodule
 