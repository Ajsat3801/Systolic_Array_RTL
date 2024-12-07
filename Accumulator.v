module Accumulator #(
    parameter ARR_SIZE=4
)(
    input clk
    input [4:0] op_buffer_address,
    input [ARR_SIZE*32:0] accumulated_val,
    output reg [31:0] output_data,
    output reg [3:0] output_buffer_addr,
);
endmodule