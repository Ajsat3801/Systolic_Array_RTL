module SystolicArray (
	clk,
	rst,
	external_clk,
	accelerator_input,
	accelerator_output,
	buffer_full
);
	parameter ARR_SIZE = 4;
	input clk;
	input rst;
	input external_clk;
	input [63:0] accelerator_input;
	output reg [31:0] accelerator_output;
	output reg buffer_full;
	wire [63:0] instr_buffer_to_controller;
	wire [6:0] controller_to_inp_buf_addr;
	wire [31:0] controller_to_inp_buf_data;
	wire [6:0] controller_to_wt_buf_addr;
	wire [31:0] controller_to_wt_buf_data;
	wire [3:0] controller_to_acc_op_addr;
	wire controller_to_acc_send_op;
	wire [3:0] controller_to_op_buf_addr;
	wire controller_to_op_buf_instr;
	wire instr_for_accum_to_reset;
	wire [1:0] state_signal;
	wire i_mode;
	wire buffer_full_wire;
	instruction_buffer instr_buffer_instance(
		.clk(clk),
		.rst(rst),
		.external_clk(external_clk),
		.interface_input(accelerator_input),
		.instr_to_controller(instr_buffer_to_controller),
		.buffer_full(buffer_full_wire)
	);
	controller controller_instance(
		.clk(clk),
        .rst(rst),
		.instruction(instr_buffer_to_controller),
		.inp_buf_addr(controller_to_inp_buf_addr),
		.inp_buf_data(controller_to_inp_buf_data),
		.wt_buf_addr(controller_to_wt_buf_addr),
		.wt_buf_data(controller_to_wt_buf_data),
		.acc_to_op_buf_addr(controller_to_acc_op_addr),
		.acc_result_to_op_buf(controller_to_acc_send_op),
		.acc_to_op_buf_addr(controller_to_op_buf_addr),
		.op_buffer_instr_for_sending_data(controller_to_op_buf_instr),
		.instr_for_accum_to_reset(instr_for_accum_to_reset),
		.state_signal(state_signal),
		.i_mode(i_mode)
	);
	wire [(32 * ARR_SIZE) - 1:0] mac_to_accumulator;
	wire [(16 * ARR_SIZE) - 1:0] mac_vertical_input;
	wire [(16 * ARR_SIZE) - 1:0] mac_horizontal_input;
	MAC mac_instance(
		.clk(clk),
		.i_mode(i_mode),
		.rst(rst),
		.vertical_input(mac_vertical_input),
		.horizontal_input(mac_horizontal_input),
		.MAC_OP(mac_to_accumulator)
	);
	wire [31:0] acc_to_op_buf_data;
	wire [3:0] acc_to_op_buf_addr;
	wire acc_to_op_buf_enable;
	wire [31:0] op_buf_output;
	Output_buffer Output_buffer_instance(
		.clk(clk),
		.rst(rst),
		.data(acc_to_op_buf_data),
		.op_buf_addr_for_store(acc_to_op_buf_addr),
		.op_buf_addr_for_external_comm(controller_to_op_buf_addr),
		.op_buffer_instr_for_storing_data(acc_to_op_buf_enable),
		.op_buffer_instr_for_sending_data(controller_to_op_buf_instr),
		.res_to_external(op_buf_output)
	);
	Accumulator Accumulator_instance(
		.clk(clk),
		.rst(rst),
		.op_buffer_address(controller_to_acc_op_addr),
		.accumulated_val(mac_to_accumulator),
		.acc_reset(instr_for_accum_to_reset),
		.store_output(controller_to_acc_send_op),
		.output_data(acc_to_op_buf_data),
		.output_buffer_addr(acc_to_op_buf_addr),
		.output_buffer_enable(acc_to_op_buf_enable),
	);
	BankedBuffer weight_buffer_instance(
		.clk(clk),
		.rst(rst),
		.data_in(controller_to_wt_buf_data),
		.addr(controller_to_wt_buf_addr),
		.state(state_signal),
		.data_out(mac_vertical_input)
	);
	BankedBuffer input_buffer_instance(
		.clk(clk),
		.rst(rst),
		.data_in(controller_to_inp_buf_data),
		.addr(controller_to_inp_buf_addr),
		.state(state_signal),
		.data_out(mac_horizontal_input)
	);
	always @(posedge clk) begin
        accelerator_output <= (rst==1) ? 32'b00000000000000000000000000000000 : op_buf_output;
        buffer_full <= (rst==1) ? 1'b0 : buffer_full_wire;
	end
endmodule