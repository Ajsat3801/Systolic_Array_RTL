module Output_buffer (
	clk,
	rst,
	data,
	op_buf_addr_for_store,
	op_buf_addr_for_external_comm,
	op_buffer_instr_for_storing_data,
	op_buffer_instr_for_sending_data,
	res_to_external
);
	input clk;
	input rst;
	input [31:0] data;
	input [3:0] op_buf_addr_for_store;
	input [3:0] op_buf_addr_for_external_comm;
	input op_buffer_instr_for_storing_data;
	input op_buffer_instr_for_sending_data;
	output reg [31:0] res_to_external;
	reg [31:0] buf_data [0:15];
	always @(posedge clk) begin
		if (op_buffer_instr_for_sending_data == 1'b1)
			res_to_external <= buf_data[op_buf_addr_for_external_comm];
		if (op_buffer_instr_for_storing_data == 1'b1)
			buf_data[op_buf_addr_for_store] <= data;
	end
	always @(posedge clk) begin : sv2v_autoblock_1
		integer i;
		for (i = 0; i < 16; i = i + 1)
			buf_data[i] <= 32'b00000000000000000000000000000000;
	end
endmodule