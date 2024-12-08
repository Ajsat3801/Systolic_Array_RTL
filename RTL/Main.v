// TODO: reset

module accelerator #(
    parameter ARR_SIZE = 4
){
    input clk,
    input external_clk,
    input [63:0] accelerator_input,
    output reg [31:0] accelerator_output,
    output reg buffer_full
}

wire [63:0] instr_buffer_to_controller;

wire [14:0] controller_to_inp_buf_addr;
wire [31:0] controller_to_inp_buf_data;
wire [14:0] controller_to_wt_buf_addr;
wire [31:0] controller_to_wt_buf_data;
wire [3:0] controller_to_acc_op_addr;
wire controller_to_acc_reset;
wire [3:0] controller_to_op_buf_addr;
wire controller_to_op_buf_instr;
wire instr_for_accum_to_reset;
wire [1:0] state_signal;


instruction_buffer instr_buffer_instance(
    .clk(clk),
    .external_clk(external_clk),
    .interface_input(accelerator_input),
    .instr_to_controller(instr_buffer_to_controller),
    .buffer_full(buffer_full)
);

controller controller_instance(
    .clk(clk),
    .instruction(instr_buffer_to_controller),
    .inp_buf_addr(controller_to_inp_buf_addr),
    .inp_buf_data(controller_to_inp_buf_data),
    .wt_buf_addr(controller_to_wt_buf_addr),
    .wt_buf_data(controller_to_wt_buf_data),
    .acc_to_op_buf_addr(controller_to_acc_op_addr),
    .acc_result_to_op_buf(controller_to_acc_reset),
    .acc_to_op_buf_addr(controller_to_op_buf_addr),
    .op_buffer_instr_for_sending_data(controller_to_op_buf_instr),
    .instr_for_accum_to_reset(instr_for_accum_to_reset),
    .state_signal(state_signal)
);

wire [32*ARR_SIZE-1:0] mac_to_accumulator;

MAC mac_instance(

);

wire [31:0] acc_to_op_buf_data;
wire [3:0] acc_to_op_buf_addr;
wire [3:0] controller_to_op_buf_addr;

Output_buffer Output_buffer_instance(
    .clk(clk),
    .data(acc_to_op_buf_data),
    .op_buf_addr_for_store(acc_to_op_buf_addr),
    .op_buf_addr_for_external_comm(controller_to_op_buf_addr),
    .op_buffer_instr_for_sending_data(controller_to_op_buf_instr),
    .res_to_external(accelerator_output)
);

wire [ARR_SIZE*32-1: 0] mac_to_accumulator;

Accumulator Accumulator_instance(
    .clk(clk)
    .op_buffer_address(controller_to_acc_op_addr),
    .accumulated_val(mac_to_accumulator),
    .acc_reset(controller_to_acc_reset),
    .output_data(acc_to_op_buf_data),
    .output_buffer_addr(acc_to_op_buf_addr)
);

Buffer weight_buffer_instance (
    .clk(clk),
    .reset(reset),
    .data_in(weight_data_in),
    .addr(weight_addr),
    .state(weight_state), // Control signal: 00, 01, or 10
    .data_out(weight_data_out),
    .empty(weight_empty),
    .full(weight_full)
);

Buffer input_buffer_instance (
    .clk(clk),
    .reset(reset),
    .data_in(input_data_in),
    .addr(input_addr),
    .state(input_state), // Control signal: 00, 01, or 10
    .data_out(input_data_out),
    .empty(input_empty),
    .full(input_full)
);



endmodule