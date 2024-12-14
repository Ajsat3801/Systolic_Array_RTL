`timescale 1ns / 1ps


module BankedBuffer #(
    parameter ARR_SIZE = 4
) (
    input wire clk,            // Clock signal
    input wire rst,            // Reset signal
    input wire [15:0] data_in, // 32-bit input data
    input wire [7:0] addr,    // 14-bit address for 2^14 elements
    input wire [1:0] state,    // Two-bit state: 00 = No operation, 01 = Store, 10 = Stream
    output reg [63:0] data_out // 64-bit output data (2 concatenated 32-bit elements)
);

// Structural logic

wire[ARR_SIZE*16-1:] op_wire;

genvar = i;
generate
    for (i = 0; i < ARR_SIZE; i = i + 1) begin : module_instances
            indivudual_buffer inst (
                .clk(clk),
                .rst(rst),
                .individual_input((addr == i) ? data_in : 16'b0), // Input goes to the selected instance
                .state((state != 2'b01) ? ((addr == i) ? state : 2'b00) : state)
                .individual_output(op_wire[(i+1)*16-1:i*16])
            );
        end
endgenerate

// Procedural at clock edge
always @(posedge clk) begin
    data_out <= op_wire;
end
// Prodecural at Rst

endmodule

// Logic for state variable (state != 2'b01) ? ((addr == i) ? state : 2'b00) : state
// TODO: can try inputting 32 bits at a time. Could end up being complex
/*
Notes: 
1) We need less bytes in the address
2) if only 16 bits of data is used, we can potentially reduce the OPCODE size to 32. Beneficial but may be work

*/
