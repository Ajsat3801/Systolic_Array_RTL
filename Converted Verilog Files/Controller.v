module controller (
	clk,
	instruction,
	inp_buf_addr,
	inp_buf_data,
	wt_buf_addr,
	wt_buf_data,
	acc_to_op_buf_addr,
	acc_result_to_op_buf,
	out_buf_addr,
	op_buffer_instr_for_sending_data,
	instr_for_accum_to_reset,
	state_signal,
	i_mode
);
	input clk;
	input [63:0] instruction;
	output reg [6:0] inp_buf_addr;
	output reg [31:0] inp_buf_data;
	output reg [6:0] wt_buf_addr;
	output reg [31:0] wt_buf_data;
	output reg [3:0] acc_to_op_buf_addr;
	output reg acc_result_to_op_buf;
	output reg [3:0] out_buf_addr;
	output reg op_buffer_instr_for_sending_data;
	output reg instr_for_accum_to_reset;
	output reg [1:0] state_signal;
	output reg i_mode;

    wire [4:0] opcode_wire;
    wire [6:0] address_wire;
    wire [31:0] data_wire;

    assign opcode_wire = instruction[4:0];
    assign address_wire = instruction[10:5];
    assign data_wire = instruction[42:11];


	always @(posedge clk) begin
		inp_buf_addr = 7'b0000000;
		inp_buf_data = 32'b00000000000000000000000000000000;
		wt_buf_addr = 7'b0000000;
		wt_buf_data = 32'b00000000000000000000000000000000;
		acc_to_op_buf_addr = 4'b0000;
		acc_result_to_op_buf = 1'b0;
		out_buf_addr = 4'b0000;
		op_buffer_instr_for_sending_data = 1'b0;
		instr_for_accum_to_reset = 1'b0;
		state_signal = 2'b00;
		i_mode = 1'b0;
		case (opcode_wire)
			5'b00000:
				;
			5'b11111:
				;
			5'b00001: state_signal = 2'b10;
			5'b00010: begin
				state_signal = 2'b10;
				i_mode = 1'b1;
			end
			5'b00011: begin
				state_signal = 2'b01;
				acc_to_op_buf_addr = address_wire[3:0];
				acc_result_to_op_buf = 1'b1;
			end
			5'b00100: begin
				state_signal = 2'b01;
				inp_buf_addr = address_wire[6:0];
				inp_buf_data = data_wire;
			end
			5'b00101: begin
				state_signal = 2'b01;
				wt_buf_addr = address_wire[6:0];
				wt_buf_data = data_wire;
			end
			5'b00110: begin
				out_buf_addr = address_wire[3:0];
				op_buffer_instr_for_sending_data = 1'b1;
			end
			5'b00111: instr_for_accum_to_reset = 1'b1;
			default:
				;
		endcase
	end
endmodule