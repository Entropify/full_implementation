/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

 module control_unit (
    input wire [6:0] control_in,
    output reg branch,
    output reg mem_read,
    output reg [1:0] mem_to_reg, // 00 write alu, 01 write ram, 10 write pc + 4, 11 bypass alu (immgen to rd)
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src1, //future jerry remember that 0 = rs1, 1 = pc
    output reg alu_src2, //0 = rs2, 1 = immgen out
    output reg reg_write,
    output reg [1:0] pc_src //remember 00 normal pc+4, 01 pc+imm, 10 alu result for jalr
 );

 always @(*) begin

    case (control_in)

    7'b0110011: begin // R-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b00;
        alu_op = 2'b10;
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b0;
        reg_write = 1'b1;
        pc_src = 2'b00;
    end

    7'b0000011: begin // I-type (lw)
        branch = 1'b0; 
        mem_read = 1'b1;
        mem_to_reg = 2'b01;
        alu_op = 2'b00;
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b1;
        reg_write = 1'b1;
        pc_src = 2'b00;
    end

    7'b0100011: begin // S-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b00;
        alu_op = 2'b00;
        mem_write = 1'b1;
        alu_src1 = 1'b0;
        alu_src2 = 1'b1;
        reg_write = 1'b0;
        pc_src = 2'b00;
    end

    7'b1100011: begin // B-type
        branch = 1'b1; 
        mem_read = 1'b0;
        mem_to_reg = 2'b00;
        alu_op = 2'b01;
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b0;
        reg_write = 1'b0;
        pc_src = 2'b00;
    end

    7'b0010011: begin // I-type (alu math)
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b00;
        alu_op = 2'b11; // remember ts gng </3
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b1;
        reg_write = 1'b1;
        pc_src = 2'b00;
    end

    7'b1100111: begin // jalr I-type jump
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b10;
        alu_op = 2'b00; 
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b1;
        reg_write = 1'b1;
        pc_src = 2'b10;
    end

    7'b0010111: begin // auipc U-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b00;
        alu_op = 2'b00; 
        mem_write = 1'b0;
        alu_src1 = 1'b1;
        alu_src2 = 1'b1;
        reg_write = 1'b1;
        pc_src = 2'b00;
    end

    7'b0110111: begin // lui U-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b11;
        alu_op = 2'b00; 
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b0;
        reg_write = 1'b1;
        pc_src = 2'b00;
    end

    7'b1101111: begin // jal UJ-type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b10;
        alu_op = 2'b00; 
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b0;
        reg_write = 1'b1;
        pc_src = 2'b01;
    end

    default: begin // safety for unknown instruction type
        branch = 1'b0; 
        mem_read = 1'b0;
        mem_to_reg = 2'b00;
        alu_op = 2'b00; 
        mem_write = 1'b0;
        alu_src1 = 1'b0;
        alu_src2 = 1'b0;
        reg_write = 1'b0;
        pc_src = 2'b00;
    end

    endcase

 end


 endmodule
 