module individual_buffer (
	clk,
	rst,
	individual_input,
	state,
	individual_output
);
	parameter ARR_SIZE = 4;
	input clk;
	input rst;
	input [15:0] individual_input;
	input [1:0] state;
	output reg [15:0] individual_output;
	parameter QUEUE_DEPTH = ARR_SIZE * 2;
	parameter ADDR_WIDTH = $clog2(QUEUE_DEPTH);
	reg [15:0] queue [QUEUE_DEPTH - 1:0];
	reg [ADDR_WIDTH - 1:0] head;
	reg [ADDR_WIDTH - 1:0] tail;
	reg [ADDR_WIDTH:0] count;
	initial begin
		head = 0;
		tail = 0;
		count = 0;
		individual_output = 16'b0000000000000000;
	end
	always @(posedge clk)
		if (state == 2'b01) begin
			queue[tail] <= individual_input;
			tail <= (tail + 1) % QUEUE_DEPTH;
			count <= count + 1;
		end
		else if (state == 2'b10) begin
			individual_output <= queue[head];
			head <= (head + 1) % QUEUE_DEPTH;
			count <= count - 1;
		end
		else if (state == 2'b00)
			individual_output <= 16'b0000000000000000;
	always @(posedge rst) begin
		head = 0;
		tail = 0;
		queue[0] = 16'b0000000000000000;
	end
endmodule