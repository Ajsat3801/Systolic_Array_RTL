`timescale 1ns/1ps

module instruction_buffer (
    input clk,
    input rst,
    input external_clk, //External interface clock assuming both are different
    input [63:0] interface_input,    //64-bit input from the external interface
    output reg [63:0] instr_to_controller, //64-bit output to the controller
    output reg buffer_full                  //Signal indicating the buffer is buffer_full
);

    // Parameters for the queue
    parameter QUEUE_DEPTH = 64; //Maximum number of instructions in the queue
    parameter ADDR_WIDTH = 6;   //Number of bits needed to address memory locations - log2(QUEUE_DEPTH)

    // FIFO queue
    reg [63:0] queue [QUEUE_DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] head, tail;
    reg [ADDR_WIDTH:0] count; //Number of instructions in the queue

    //Initialisation
    initial begin
        head = 0;
        tail = 0;
        count = 0;
        buffer_full = 0;
        instr_to_controller = 64'b0;
    end

    always @(posedge external_clk) begin
        // Check if the buffer is full
        buffer_full <= (count == QUEUE_DEPTH);

        // Enqueue - Load instruction from interface to the queue
        if (!buffer_full) begin
            queue[tail] <= interface_input;  // Load instruction to the queue
            tail <= (tail + 1) % QUEUE_DEPTH; // Increment tail pointer (go back to 0 when its the end, stay in the range 0 to QUEUE_DEPTH-1)
            count <= count + 1;             // Increment instruction count
        end
    end
    always @(posedge clk) begin
        
        if(rst==1)begin
            head = 0;
            tail = 0;
            queue[0] = 64'b0;
        end
        
        
        else begin
            if (count > 0) begin // Dequeue - Send instruction to the controller
                instr_to_controller <= queue[head]; // Send instruction to controller
                head <= (head + 1) % QUEUE_DEPTH;   // Increment head pointer (refer comment for tail)
                count <= count - 1;               // Decrement instruction count
            end
        end

        
    end

endmodule
