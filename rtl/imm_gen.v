/*
 * Copyright (c) 2026 Zhiyuan (Jerry) Jiang
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

 module imm_gen (
    input wire [31:0] instruction_in,
    output reg [31:0] imm_gen_out
 );

 always @(*) begin
    case (instruction_in[6:0])

    7'b0000011: begin // I-type lw
        imm_gen_out = {{20{instruction_in[31]}},instruction_in[31:20]};
    end

    7'b0010011: begin // I-type math
        imm_gen_out = {{20{instruction_in[31]}},instruction_in[31:20]};
    end

    7'b0100011: begin // S-type
        imm_gen_out = {{20{instruction_in[31]}},instruction_in[31:25],instruction_in[11:7]};
    end

    7'b1100011: begin // B-type
        imm_gen_out = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
    end

    default: begin
        imm_gen_out = 32'h0000_0000;
    end

    endcase
 end

 endmodule
 