module bfp32_adder (
	clk,
	rst,
	A,
	B,
	O
);
	input clk;
	input rst;
	input [31:0] A;
	input [31:0] B;
	output reg [31:0] O;
	wire a_sign;
	wire b_sign;
	wire [7:0] a_exponent;
	wire [7:0] b_exponent;
	wire [23:0] a_mantissa;
	wire [23:0] b_mantissa;
	reg o_sign;
	reg [7:0] o_exponent;
	reg [24:0] o_mantissa;
	reg [31:0] adder_a_in;
	reg [31:0] adder_b_in;
	wire [31:0] adder_out;
	assign a_sign = A[31];
	assign a_exponent[7:0] = A[30:23];
	assign a_mantissa[23:0] = {1'b1, A[22:0]};
	assign b_sign = B[31];
	assign b_exponent[7:0] = B[30:23];
	assign b_mantissa[23:0] = {1'b1, B[22:0]};
	generalAdder gAdder(
		.a(adder_a_in),
		.b(adder_b_in),
		.out(adder_out)
	);
	wire [32:1] sv2v_tmp_BF447;
	assign sv2v_tmp_BF447 = A;
	always @(*) adder_a_in = sv2v_tmp_BF447;
	wire [32:1] sv2v_tmp_16657;
	assign sv2v_tmp_16657 = B;
	always @(*) adder_b_in = sv2v_tmp_16657;
	always @(*)
		if (rst == 1'b1)
			O = 32'd0;
		else if (((a_exponent == 255) && (a_mantissa[22:0] != 0)) || ((b_exponent == 0) && (b_mantissa[22:0] == 0))) begin
			o_sign = a_sign;
			o_exponent = a_exponent;
			o_mantissa = a_mantissa;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end
		else if (((b_exponent == 255) && (b_mantissa[22:0] != 0)) || ((a_exponent == 0) && (a_mantissa[22:0] == 0))) begin
			o_sign = b_sign;
			o_exponent = b_exponent;
			o_mantissa = b_mantissa;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end
		else if ((a_exponent == 255) || (b_exponent == 255)) begin
			o_sign = a_sign ^ b_sign;
			o_exponent = 255;
			o_mantissa = 0;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end
		else begin
			o_sign = adder_out[31];
			o_exponent = adder_out[30:23];
			o_mantissa = adder_out[22:0];
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end
endmodule
module generalAdder (
	a,
	b,
	out
);
	input [31:0] a;
	input [31:0] b;
	output wire [31:0] out;
	reg a_sign;
	reg b_sign;
	reg [7:0] a_exponent;
	reg [7:0] b_exponent;
	reg [23:0] a_mantissa;
	reg [23:0] b_mantissa;
	reg o_sign;
	reg [7:0] o_exponent;
	reg [24:0] o_mantissa;
	reg [7:0] diff;
	reg [23:0] tmp_mantissa;
	reg [7:0] i_e;
	reg [24:0] i_m;
	wire [7:0] o_e;
	wire [24:0] o_m;
	addition_normaliser norm1(
		.in_e(i_e),
		.in_m(i_m),
		.out_e(o_e),
		.out_m(o_m)
	);
	assign out[31] = o_sign;
	assign out[30:23] = o_exponent;
	assign out[22:0] = o_mantissa[22:0];
	always @(*) begin
		a_sign = a[31];
		if (a[30:23] == 0) begin
			a_exponent = 8'b00000001;
			a_mantissa = {1'b0, a[22:0]};
		end
		else begin
			a_exponent = a[30:23];
			a_mantissa = {1'b1, a[22:0]};
		end
		b_sign = b[31];
		if (b[30:23] == 0) begin
			b_exponent = 8'b00000001;
			b_mantissa = {1'b0, b[22:0]};
		end
		else begin
			b_exponent = b[30:23];
			b_mantissa = {1'b1, b[22:0]};
		end
		if (a_exponent == b_exponent) begin
			o_exponent = a_exponent;
			if (a_sign == b_sign) begin
				o_mantissa = a_mantissa + b_mantissa;
				o_mantissa[24] = 1;
				o_sign = a_sign;
			end
			else if (a_mantissa > b_mantissa) begin
				o_mantissa = a_mantissa - b_mantissa;
				o_sign = a_sign;
			end
			else begin
				o_mantissa = b_mantissa - a_mantissa;
				o_sign = b_sign;
			end
		end
		else if (a_exponent > b_exponent) begin
			o_exponent = a_exponent;
			o_sign = a_sign;
			diff = a_exponent - b_exponent;
			tmp_mantissa = b_mantissa >> diff;
			if (a_sign == b_sign)
				o_mantissa = a_mantissa + tmp_mantissa;
			else
				o_mantissa = a_mantissa - tmp_mantissa;
		end
		else if (a_exponent < b_exponent) begin
			o_exponent = b_exponent;
			o_sign = b_sign;
			diff = b_exponent - a_exponent;
			tmp_mantissa = a_mantissa >> diff;
			if (a_sign == b_sign)
				o_mantissa = b_mantissa + tmp_mantissa;
			else
				o_mantissa = b_mantissa - tmp_mantissa;
		end
		if (o_mantissa[24] == 1) begin
			o_exponent = o_exponent + 1;
			o_mantissa = o_mantissa >> 1;
		end
		else if ((o_mantissa[23] != 1) && (o_exponent != 0)) begin
			i_e = o_exponent;
			i_m = o_mantissa;
			o_exponent = o_e;
			o_mantissa = o_m;
		end
	end
endmodule
module addition_normaliser (
	in_e,
	in_m,
	out_e,
	out_m
);
	input wire [7:0] in_e;
	input wire [24:0] in_m;
	output reg [7:0] out_e;
	output reg [24:0] out_m;
	always @(*)
		if (in_m[23:3] == 21'b000000000000000000001) begin
			out_e = in_e - 20;
			out_m = in_m << 20;
		end
		else if (in_m[23:4] == 20'b00000000000000000001) begin
			out_e = in_e - 19;
			out_m = in_m << 19;
		end
		else if (in_m[23:5] == 19'b0000000000000000001) begin
			out_e = in_e - 18;
			out_m = in_m << 18;
		end
		else if (in_m[23:6] == 18'b000000000000000001) begin
			out_e = in_e - 17;
			out_m = in_m << 17;
		end
		else if (in_m[23:7] == 17'b00000000000000001) begin
			out_e = in_e - 16;
			out_m = in_m << 16;
		end
		else if (in_m[23:8] == 16'b0000000000000001) begin
			out_e = in_e - 15;
			out_m = in_m << 15;
		end
		else if (in_m[23:9] == 15'b000000000000001) begin
			out_e = in_e - 14;
			out_m = in_m << 14;
		end
		else if (in_m[23:10] == 14'b00000000000001) begin
			out_e = in_e - 13;
			out_m = in_m << 13;
		end
		else if (in_m[23:11] == 13'b0000000000001) begin
			out_e = in_e - 12;
			out_m = in_m << 12;
		end
		else if (in_m[23:12] == 12'b000000000001) begin
			out_e = in_e - 11;
			out_m = in_m << 11;
		end
		else if (in_m[23:13] == 11'b00000000001) begin
			out_e = in_e - 10;
			out_m = in_m << 10;
		end
		else if (in_m[23:14] == 10'b0000000001) begin
			out_e = in_e - 9;
			out_m = in_m << 9;
		end
		else if (in_m[23:15] == 9'b000000001) begin
			out_e = in_e - 8;
			out_m = in_m << 8;
		end
		else if (in_m[23:16] == 8'b00000001) begin
			out_e = in_e - 7;
			out_m = in_m << 7;
		end
		else if (in_m[23:17] == 7'b0000001) begin
			out_e = in_e - 6;
			out_m = in_m << 6;
		end
		else if (in_m[23:18] == 6'b000001) begin
			out_e = in_e - 5;
			out_m = in_m << 5;
		end
		else if (in_m[23:19] == 5'b00001) begin
			out_e = in_e - 4;
			out_m = in_m << 4;
		end
		else if (in_m[23:20] == 4'b0001) begin
			out_e = in_e - 3;
			out_m = in_m << 3;
		end
		else if (in_m[23:21] == 3'b001) begin
			out_e = in_e - 2;
			out_m = in_m << 2;
		end
		else if (in_m[23:22] == 2'b01) begin
			out_e = in_e - 1;
			out_m = in_m << 1;
		end
endmodule