module PE (
	clk,
	rst,
	i_mode,
	i_top,
	i_left,
	o_bot,
	o_right
);
	parameter ADD_BW = 32;
	parameter MUL_BW = 16;
	input clk;
	input rst;
	input i_mode;
	input [ADD_BW - 1:0] i_top;
	input [MUL_BW - 1:0] i_left;
	output reg [ADD_BW - 1:0] o_bot;
	output reg [MUL_BW - 1:0] o_right;
	reg [MUL_BW - 1:0] r_buffer;
	wire [MUL_BW - 1:0] w_mult_out;
	wire [ADD_BW - 1:0] w_adder_in;
	wire [ADD_BW - 1:0] w_adder_out;
	wire [ADD_BW - 1:0] w_out;
	always @(*)
		if (rst == 1'b1)
			r_buffer = 'd0;
		else if (i_mode == 1'b0)
			r_buffer = i_top[MUL_BW - 1:0];
	assign w_adder_in = (i_mode ? i_top : 'd0);
	bfp16_mult mult1(
		.clk(clk),
		.rst(rst),
		.A(i_left),
		.B(r_buffer),
		.O(w_mult_out)
	);
	bfp32_adder adder1(
		.clk(clk),
		.rst(rst),
		.A(w_adder_in),
		.B({w_mult_out, 16'b0000000000000000}),
		.O(w_adder_out)
	);
	assign w_out = (i_mode ? w_adder_out : {16'b0000000000000000, i_top[MUL_BW - 1:0]});
	always @(posedge clk) begin
        o_bot <= (rst==1) ? 32'b0 : w_out;
        o_right <= (rst==1) ? 32'b0 : i_left;
	end
endmodule