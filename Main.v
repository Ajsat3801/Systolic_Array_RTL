// TODO: reset

module accelerator #(
    parameter ARR_SIZE = 4
){
    input clk,
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



instruction_buffer instr_buffer_instance(
    .clk(clk),
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
    .acc_to_op_buf_addr(controller_to_op_buf_addr)
);

weight_buffer weight_buffer_instance( //incomplete
    .clk(clk)

);

wire [31:0] acc_to_op_buf_data;
wire [3:0] acc_to_op_buf_addr;
wire [3:0] controller_to_op_buf_addr;

Output_buffer Output_buffer_instance(
    .clk(clk),
    .data(acc_to_op_buf_data),
    .op_buf_addr_for_store(acc_to_op_buf_addr),
    .op_buf_addr_for_external_comm(controller_to_op_buf_addr),
    .res_to_external(accelerator_output)
);

wire [ARR_SIZE*32-1: 0] mac_to_accumulator;

Accumulator Accumulator_instance(
    .clk(clk)
    .op_buffer_address(controller_to_acc_op_addr),
    .accumulated_val(mac_to_accumulator),
    .output_data(acc_to_op_buf_data),
    .output_buffer_addr(acc_to_op_buf_addr)
)

endmodule