module Accumulator (
	clk,
	rst,
	op_buffer_address,
	accumulated_val,
	acc_reset,
	store_output,
	output_data,
	output_buffer_addr,
	output_buffer_enable
);
	parameter ARR_SIZE = 4;
	parameter VERTICAL_BW = 32;
	input clk;
	input rst;
	input [3:0] op_buffer_address;
	input [(ARR_SIZE * VERTICAL_BW) - 1:0] accumulated_val;
	input acc_reset;
	input store_output;
	output reg [31:0] output_data;
	output reg [3:0] output_buffer_addr;
	output reg output_buffer_enable;
	reg [31:0] accumulator_op; // internal register
	wire [31:0] accumulator_op_intermediate_wire [ARR_SIZE - 1:0];
    wire [3:0] op_buffer_address_wire;
    wire output_buffer_enable_wire;
    assign op_buffer_address_wire = op_buffer_address;
    assign output_buffer_enable_wire = store_output;
	genvar _gv_k_1;
	generate
		for (_gv_k_1 = 0; _gv_k_1 < ARR_SIZE; _gv_k_1 = _gv_k_1 + 1) begin : gen_final_accumulation
			localparam k = _gv_k_1;
			if (k == 0) begin : genblk1
				bfp32_adder accumulator_intermediate(
					.clk(clk),
					.rst(acc_reset || rst),
					.A(accumulated_val[((k + 1) * VERTICAL_BW) - 1:k * VERTICAL_BW]),
					.B(accumulated_val[((k + 2) * VERTICAL_BW) - 1:(k + 1) * VERTICAL_BW]),
					.O(accumulator_op_intermediate_wire[k])
				);
			end
			else if (k == (ARR_SIZE - 1)) begin : genblk1
				bfp32_adder accumulator_intermediate(
					.clk(clk),
					.rst(acc_reset || rst),
					.A(accumulator_op_intermediate_wire[k - 1]),
					.B(accumulator_op),
					.O(accumulator_op_intermediate_wire[k])
				);
			end
			else begin : genblk1
				bfp32_adder accumulator_intermediate(
					.clk(clk),
					.rst(acc_reset || rst),
					.A(accumulator_op_intermediate_wire[k - 1]),
					.B(accumulated_val[((k + 2) * VERTICAL_BW) - 1:(k + 1) * VERTICAL_BW]),
					.O(accumulator_op_intermediate_wire[k])
				);
			end
		end
	endgenerate
	always @(posedge clk) begin
		output_data = (store_output== 1'b1 | rst==0) ? accumulator_op: 32'b00000000000000000000000000000000 ;
        accumulator_op = (rst==0) ? accumulator_op_intermediate_wire[ARR_SIZE - 1] : 32'b00000000000000000000000000000000 ;
        output_buffer_addr = (store_output== 1'b1 | rst==0) ? op_buffer_address_wire : 4'b0000;
        output_buffer_enable = (store_output== 1'b1 | rst==0) ? output_buffer_enable_wire : 1'b0;
	end
endmodule