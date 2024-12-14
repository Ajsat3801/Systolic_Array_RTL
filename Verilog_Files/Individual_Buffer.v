`timescale 1ns/1ps

module individual_buffer #(
    parameter ARR_SIZE = 4 
)(
    input clk,
    input rst,
    input [15:0] individual_input,    //64-bit input from the external interface
    input [1:0] state,
    output reg [15:0] individual_output //64-bit output to the controller
);
    
    parameter QUEUE_DEPTH = ARR_SIZE*2; //Maximum number of instructions in the queue
    parameter ADDR_WIDTH = $clog2(QUEUE_DEPTH);   //Number of bits needed to address memory locations - log2(QUEUE_DEPTH)

    // FIFO queue
    reg [15:0] queue [QUEUE_DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] head, tail;
    reg [ADDR_WIDTH:0] count; //Number of instructions in the queue

    //Initialisation
    initial begin
        head = 0;
        tail = 0;
        count = 0;
        individual_output = 16'b0;
    end
    
    always @(posedge clk) begin

        // Enqueue - Load instruction from interface to the queue
        if (state == 2'b01) begin
            queue[tail] <= individual_input;  // Load instruction to the queue
            tail <= (tail + 1) % QUEUE_DEPTH; // Increment tail pointer (go back to 0 when its the end, stay in the range 0 to QUEUE_DEPTH-1)
            count <= count + 1;             // Increment instruction count
        end
        
        else if (state == 2'b10) begin // Dequeue - Send instruction to the controller
            individual_output <= queue[head]; // Send instruction to controller
            head <= (head + 1) % QUEUE_DEPTH;   // Increment head pointer (refer comment for tail)
            count <= count - 1;               // Decrement instruction count
        end
        else if (state == 2'b00) begin
            // No operation: Hold state
            individual_output <= 16'b0;
        end
    end

    always @(posedge rst) begin
        
        head = 0;
        tail = 0;
        queue[0] = 16'b0;
    end


endmodule
