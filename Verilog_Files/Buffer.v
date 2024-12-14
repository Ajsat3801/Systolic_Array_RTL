`timescale 1ns / 1ps


module Buffer (
    input wire clk,            // Clock signal
    input wire rst,          // Reset signal
    input wire [31:0] data_in, // 32-bit input data
    input wire [13:0] addr,    // 14-bit address for 2^14 elements
    input wire [1:0] state,    // Two-bit state: 00 = No operation, 01 = Store, 10 = Stream
    output reg [63:0] data_out // 64-bit output data (2 concatenated 32-bit elements)
);

    // Define buffer size for 2^14 32-bit words
    parameter BUFFER_SIZE = 128;
    reg [31:0] fifo [0:BUFFER_SIZE-1]; // FIFO memory
    reg [13:0] write_ptr = 0;          // Write pointer
    reg [13:0] read_ptr = 0;           // Read pointer
    reg [13:0] count = 0;              // Counter for elements in the buffer

    // Write logic (state = 01)
    always @(posedge clk) begin

        if (state == 2'b01) begin
            fifo[write_ptr] <= data_in;           // Store input data
            write_ptr <= (write_ptr + 1) % BUFFER_SIZE; // Increment write pointer
            count <= count + 1;                  // Increment the count of elements
        end

        // Streaming logic (state = 10)
        if (state == 2'b10) begin
            // Stream two consecutive 32-bit elements as 64-bit output
            data_out <= {fifo[read_ptr], fifo[(read_ptr + 1) % BUFFER_SIZE]}; 
            read_ptr <= (read_ptr + 2) % BUFFER_SIZE; // Increment read pointer by 2
            count <= count - 2;                      // Decrement the count of elements
        end

        // No operation (state = 00)
        if (state == 2'b00) begin
            // No operation: Hold state
            data_out <= 64'b0;
        end
    end

    always @(posedge clk) begin

        fifo[0] <= 32'b0;
        write_ptr <= 0;
        read_ptr <=0;
    end

endmodule
