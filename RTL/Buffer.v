module Buffer (
    input wire clk,            // Clock signal
    input wire reset,          // Reset signal
    input wire [31:0] data_in, // 32-bit input data
    input wire [13:0] addr,    // 14-bit address for 2^14 elements
    input wire write_enable,   // Enable signal for writing
    output reg [63:0] data_out, // 64-bit output data (2 concatenated 32-bit elements)
    output reg empty,          // Flag to indicate the buffer is empty
    output reg full            // Flag to indicate the buffer is full
);

    // Define buffer size for 2^14 32-bit words
    parameter BUFFER_SIZE = 16384;
    reg [31:0] fifo [0:BUFFER_SIZE-1]; // FIFO memory
    reg [13:0] write_ptr = 0;          // Write pointer
    reg [13:0] read_ptr = 0;           // Read pointer
    reg [13:0] count = 0;              // Counter for elements in the buffer

    // Empty and Full flag logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            empty <= 1;
            full <= 0;
        end else begin
            empty <= (count == 0);
            full <= (count == BUFFER_SIZE);
        end
    end

    // Write logic (when MSB of address is 0)
    always @(posedge clk) begin
        if (write_enable && !full && addr[13] == 0) begin
            fifo[write_ptr] <= data_in;
            write_ptr <= (write_ptr + 1) % BUFFER_SIZE;
            count <= count + 1;
        end
    end

    // Read and stream logic (when MSB of address is 1)
    always @(posedge clk) begin
        if (addr[13] == 1 && !empty) begin
            data_out <= {fifo[read_ptr], fifo[(read_ptr + 1) % BUFFER_SIZE]}; // Concatenate two 32-bit words
            read_ptr <= (read_ptr + 2) % BUFFER_SIZE; // Increment by 2 for reading two elements
            count <= count - 2;
        end
    end

endmodule
