`timescale 1ns / 1ps

module Accumulator #(
    parameter ARR_SIZE = 4,
    parameter VERTICAL_BW = 32
)(
    input clk,
    input rst,
    input [3:0] op_buffer_address,
    input [ARR_SIZE * VERTICAL_BW - 1:0] accumulated_val,
    input acc_reset,
    input store_output,
    output reg [31:0] output_data,
    output reg [3:0] output_buffer_addr,
    output reg output_buffer_enable
);

    reg [31:0] accumulator_op = 32'b0;
    wire [31:0] accumulator_op_intermediate_wire[ARR_SIZE - 1:0];

    generate
        for (genvar k = 0; k < ARR_SIZE; k = k + 1) begin : gen_final_accumulation

            if (k==0) begin // Left-most element
                bfp32_adder accumulator_intermediate( 
                    .clk(clk),
                    .rst(acc_reset || rst),
                    .A(accumulated_val[(k+1) * VERTICAL_BW - 1 : k * VERTICAL_BW]),
                    .B(accumulated_val[(k+2) * VERTICAL_BW - 1 : (k+1) * VERTICAL_BW]),
                    .O(accumulator_op_intermediate_wire[k]) 
                );
            end

            else if(k==ARR_SIZE-1) begin // Right-most element
                bfp32_adder accumulator_intermediate( 
                    .clk(clk),
                    .rst(acc_reset || rst),
                    .A(accumulator_op_intermediate_wire[k-1]),
                    .B(accumulator_op),
                    .O(accumulator_op_intermediate_wire[k]) 
                );
            end

            else begin // intermediate elements
                bfp32_adder accumulator_intermediate( 
                    .clk(clk),
                    .rst(acc_reset || rst),
                    .A(accumulator_op_intermediate_wire[k-1]),
                    .B(accumulated_val[(k+2) * VERTICAL_BW - 1 : (k+1) * VERTICAL_BW]),
                    .O(accumulator_op_intermediate_wire[k]) 
                );
            end
        end
    endgenerate

    // Procedural logic with reset
    always @(posedge clk) begin
        output_data = 32'b0;

        // Update outputs
        if (store_output == 1'b1) begin
            output_data <= accumulator_op;
            output_buffer_addr <= op_buffer_address;
            output_buffer_enable <= store_output;

            // Update procedural registers with structural results
            accumulator_op <= accumulator_op_intermediate_wire[ARR_SIZE-1];
        end
    end

    // Procedural logic with reset
    always @(posedge rst) begin
        output_data = 32'b0;
        accumulator_op <= 32'b0;
    end

endmodule


