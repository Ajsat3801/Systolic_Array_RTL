module BankedBuffer (
	clk,
	rst,
	data_in,
	addr,
	state,
	data_out
);
	parameter ARR_SIZE = 4;
	input wire clk;
	input wire rst;
	input wire [31:0] data_in;
	input wire [6:0] addr;
	input wire [1:0] state;
	output reg [(ARR_SIZE * 16) - 1:0] data_out;
	wire [(ARR_SIZE * 16) - 1:0] op_wire;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < ARR_SIZE; _gv_i_1 = _gv_i_1 + 1) begin : module_instances
			localparam i = _gv_i_1;
			individual_buffer inst(
				.clk(clk),
				.rst(rst),
				.individual_input((addr == i ? data_in[15:0] : (addr == (i - 1) ? data_in[31:16] : 16'b0000000000000000))),
				.state((state != 2'b01 ? (addr == i ? state : 2'b00) : state)),
				.individual_output(op_wire[((i + 1) * 16) - 1:i * 16])
			);
		end
	endgenerate
	always @(posedge clk) data_out <= op_wire;
endmodule