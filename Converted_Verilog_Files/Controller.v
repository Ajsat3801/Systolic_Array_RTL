module controller (
	clk,
    rst,
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
        inp_buf_addr <= (rst==0 & opcode_wire==5'b00100 ) ? address_wire : 7'b0000000;
		inp_buf_data <= (rst==0 & opcode_wire==5'b00100 ) ? data_wire : 32'b00000000000000000000000000000000;
		wt_buf_addr <= (rst==0 & opcode_wire==5'b00101 ) ? address_wire : 7'b0000000;
		wt_buf_data <= (rst==0 & opcode_wire==5'b00101 ) ? data_wire : 32'b00000000000000000000000000000000;
		acc_to_op_buf_addr <= (rst==0 & opcode_wire==5'b00011 ) ? address_wire[3:0] : 4'b0000;
		acc_result_to_op_buf <= (rst==0 & opcode_wire==5'b00011 )? 1'b1 : 1'b0;
		out_buf_addr <= (rst==0 & opcode_wire==5'b00110 ) ? address_wire[3:0] : 4'b0000;
		op_buffer_instr_for_sending_data <= (rst==0 & opcode_wire==5'b00110 ) ? 1'b1 : 1'b0;
		instr_for_accum_to_reset <= (rst==0 & opcode_wire==5'b00111 ) ? 1'b1 : 1'b0;
		state_signal = (rst==0 & (opcode_wire==5'b00011 | opcode_wire==5'b00100 | opcode_wire==5'b00101))? 2'b01:((rst==0 & (opcode_wire==5'b00001 | opcode_wire==5'b00010 ))? 2'b10 : 2'b00);
		i_mode <= (rst==0 & opcode_wire==5'b00010 ) ? 1'b1 : 1'b0;
    end
endmodule

