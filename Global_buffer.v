// Global Buffer Module for TPU

module global_buffer #(parameter DATA_WIDTH = 16, // Width of the data
                       parameter ADDR_WIDTH = 10, // Address width for buffer
                       parameter DEPTH = 1024    // Depth of the buffer

                      )

(

    input clk,                      // Clock signal

    input rst,                      // Reset signal

    input write_enable,             // Write enable signal

    input read_enable,              // Read enable signal

    input [ADDR_WIDTH-1:0] addr,    // Address for read/write

    input [DATA_WIDTH-1:0] w_data,  // Data input for writing

    output reg [DATA_WIDTH-1:0] r_data // Data output for reading

);



// Internal memory for the buffer

reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];



always @(posedge clk or posedge rst) begin

    if (rst) begin

        // Reset the memory on reset signal

        integer i;

        for (i = 0; i < DEPTH; i = i + 1) begin

            memory[i] <= {DATA_WIDTH{1'b0}};

        end

    end else begin

        if (write_enable) begin

            // Write data to memory

            memory[addr] <= w_data;

        end

        if (read_enable) begin

            // Read data from memory

            r_data <= memory[addr];

        end

    end

end



endmodule