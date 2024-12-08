module Accumulator #(
    parameter ARR_SIZE=4,
    parameter VERTICAL_BW=32
)(
    input clk
    input [3:0] op_buffer_address,
    input [ARR_SIZE*VERTICAL_BW-1:0] accumulated_val,
    input acc_reset,
    input store_output,
    output reg [31:0] output_data,
    output reg [3:0] output_buffer_addr,
    output reg output_buffer_enable
);

    reg [31:0]accumulator_op;

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

        output_data = 32'b0;
        output_buffer_addr = 4'b0;
        output_buffer_enable = 1'b0;

        if(acc_reset == 1) begin
            accumulator_op <= 32'b0;
        end
        if(store_output == 1'b1) begin
            output_data <= accumulator_op;
            output_buffer_addr <= op_buffer_address;
            output_buffer_enable <= store_output;
        end
         
    end

endmodule



