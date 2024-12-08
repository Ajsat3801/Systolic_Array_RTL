module Accumulator #(
    parameter ARR_SIZE=4,
    parameter VERTICAL_BW=32
)(
    input clk
    input [4:0] op_buffer_address,
    input [ARR_SIZE*VERTICAL_BW-1:0] accumulated_val,
    input acc_reset,
    output reg [31:0] output_data,
    output reg [3:0] output_buffer_addr,
);

    generate

        for(genvar k = 0; k<ARR_SIZE; k++) begin
            
            adder accumulator(
                .clk(clk),
                .rst(rst),
                .A(accumulated_val[k*VERTICAL_BW+VERTICAL_BW-1:k*VERTICAL_BW]),
                .B(horizontal_wires[ARR_SIZE-1][k]),
                .O(accumulated_val[k*VERTICAL_BW+VERTICAL_BW-1:k*VERTICAL_BW])
            );

        end

    endgenerate

    // Add the values of the accumulated value to give final output
    generate

        for(genvar k = 0; k<ARR_SIZE; k++) begin
            
            adder accumulator(
                .clk(clk),
                .rst(rst),
                .A(accumulated_val[k*VERTICAL_BW+VERTICAL_BW-1:k*VERTICAL_BW]),
                .B(accumulator_op),
                .O(accumulator_op)
            );

        end

    endgenerate

    always @(posedge clk) begin

        
        
    end

endmodule



