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

	always @(posedge external_clk) begin
        
        if (rst == 1'b1) begin
            head = 0;
		    tail = 0;
            count = 0;
            buffer_full = 0;
		    queue[0] = 64'b0000000000000000000000000000000000000000000000000000000000000000;
        end

		buffer_full = count == QUEUE_DEPTH;
		if (!buffer_full) begin
			queue[tail] = interface_input;
			tail = (tail + 1) % QUEUE_DEPTH;
			count = count + 1;
		end

        if (clk == 1'b1) begin
            if (count > 0) begin
                instr_to_controller = queue[head];
                head = (head + 1) % QUEUE_DEPTH;
                count = count - 1;
		    end
        end

	end
endmodule