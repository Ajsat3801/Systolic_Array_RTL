module MAC (
	clk,
	i_mode,
	rst,
	vertical_input,
	horizontal_input,
	MAC_OP
);
	parameter ARR_SIZE = 4;
	parameter VERTICAL_BW = 32;
	parameter HORIZONTAL_BW = 16;
	parameter ACC_SIZE = 64;
	input clk;
	input i_mode;
	input rst;
	input [(HORIZONTAL_BW * ARR_SIZE) - 1:0] vertical_input;
	input [(HORIZONTAL_BW * ARR_SIZE) - 1:0] horizontal_input;
	output reg [(ARR_SIZE * VERTICAL_BW) - 1:0] MAC_OP;
	wire [HORIZONTAL_BW - 1:0] horizontal_wires [ARR_SIZE - 1:0][ARR_SIZE - 1:0];
	wire [VERTICAL_BW - 1:0] vertical_wires [ARR_SIZE - 1:0][ARR_SIZE - 1:0];
	wire [(ARR_SIZE * VERTICAL_BW) - 1:0] op_wire;
	genvar _gv_i_1;
	genvar _gv_j_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < ARR_SIZE; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			for (_gv_j_1 = 0; _gv_j_1 < ARR_SIZE; _gv_j_1 = _gv_j_1 + 1) begin : genblk1
				localparam j = _gv_j_1;
				if ((i == 0) && (j == 0)) begin : genblk1
					PE pe_instance_tlcorner(
						.clk(clk),
						.rst(rst),
						.i_mode(i_mode),
						.i_top({16'b0000000000000000, vertical_input[((j + 1) * HORIZONTAL_BW) - 1:j * HORIZONTAL_BW]}),
						.i_left(horizontal_input[((i + 1) * HORIZONTAL_BW) - 1:i * HORIZONTAL_BW]),
						.o_bot(vertical_wires[i][j]),
						.o_right(horizontal_wires[i][j])
					);
				end
				else if ((i == 0) && (j != 0)) begin : genblk1
					PE pe_instance_top(
						.clk(clk),
						.rst(rst),
						.i_mode(i_mode),
						.i_top({16'b0000000000000000, vertical_input[((j + 1) * HORIZONTAL_BW) - 1:j * HORIZONTAL_BW]}),
						.i_left(horizontal_wires[i][j - 1]),
						.o_bot(vertical_wires[i][j]),
						.o_right(horizontal_wires[i][j])
					);
				end
				else if ((i != 0) && (j == 0)) begin : genblk1
					PE pe_instance_left(
						.clk(clk),
						.rst(rst),
						.i_mode(i_mode),
						.i_top(vertical_wires[i - 1][j]),
						.i_left(horizontal_input[((i + 1) * HORIZONTAL_BW) - 1:i * HORIZONTAL_BW]),
						.o_bot(vertical_wires[i][j]),
						.o_right(horizontal_wires[i][j])
					);
				end
				else if ((i == (ARR_SIZE - 1)) && (j == 0)) begin : genblk1
					PE pe_instance_blcorner(
						.clk(clk),
						.rst(rst),
						.i_mode(i_mode),
						.i_top(vertical_wires[i - 1][j]),
						.i_left(horizontal_input[((i + 1) * HORIZONTAL_BW) - 1:i * HORIZONTAL_BW]),
						.o_bot(op_wire[(j + 1) * HORIZONTAL_BW:j * HORIZONTAL_BW]),
						.o_right(horizontal_wires[i][j])
					);
				end
				else if ((i == (ARR_SIZE - 1)) && (j != 0)) begin : genblk1
					PE pe_instance_bottom(
						.clk(clk),
						.rst(rst),
						.i_mode(i_mode),
						.i_top(vertical_wires[i - 1][j]),
						.i_left(horizontal_wires[i][j - 1]),
						.o_bot(op_wire[(j + 1) * HORIZONTAL_BW:j * HORIZONTAL_BW]),
						.o_right(horizontal_wires[i][j])
					);
				end
				else if ((i != 0) && (j != 0)) begin : genblk1
					PE pe_instance_middle(
						.clk(clk),
						.rst(rst),
						.i_mode(i_mode),
						.i_top(vertical_wires[i - 1][j]),
						.i_left(horizontal_wires[i][j - 1]),
						.o_bot(vertical_wires[i][j]),
						.o_right(horizontal_wires[i][j])
					);
				end
			end
		end
	endgenerate
	always @(posedge clk) MAC_OP <= op_wire;
endmodule