module instruction_buffer (
	clk,
	rst,
	external_clk,
	interface_input,
	instr_to_controller,
	buffer_full
);
	input clk;
	input rst;
	input external_clk;
	input [63:0] interface_input;
	output reg [63:0] instr_to_controller;
	output reg buffer_full;
	parameter QUEUE_DEPTH = 64;
	parameter ADDR_WIDTH = 6;
	reg [63:0] queue [QUEUE_DEPTH - 1:0];
	reg [ADDR_WIDTH - 1:0] head;
	reg [ADDR_WIDTH - 1:0] tail;
	reg [ADDR_WIDTH:0] count;
	initial begin
		head = 0;
		tail = 0;
		count = 0;
		buffer_full = 0;
		instr_to_controller = 64'b0000000000000000000000000000000000000000000000000000000000000000;
	end
	always @(posedge external_clk) begin
		buffer_full <= count == QUEUE_DEPTH;
		if (!buffer_full) begin
			queue[tail] <= interface_input;
			tail <= (tail + 1) % QUEUE_DEPTH;
			count <= count + 1;
		end
	end
	always @(posedge clk)
		if (count > 0) begin
			instr_to_controller <= queue[head];
			head <= (head + 1) % QUEUE_DEPTH;
			count <= count - 1;
		end
	always @(posedge rst) begin
		head = 0;
		tail = 0;
		queue[0] = 64'b0000000000000000000000000000000000000000000000000000000000000000;
	end
endmodule