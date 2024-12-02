module Systolic_array #(
    parameter ARR_SIZE = 2, // set to 128 during final synthesis 
    parameter VERTICAL_BW = 32,
    parameter HORIZONTAL_BW = 16,
    parameter ACC_SIZE = 64
) (
    input clk,
    input i_mode,
    input rst,
    input [VERTICAL_BW*ARR_SIZE-1:0] vertical_input,
    input [HORIZONTAL_BW*ARR_SIZE-1:0] horizontal_input,
    output reg [ARR_SIZE*HORIZONTAL_BW -1:0] accumulated_val
);

    wire [HORIZONTAL_BW*-1:0]horizontal_wires[ARR_SIZE-1:0][ARR_SIZE-1:0];
    wire [VERTICAL_BW-1:0]vertical_wires[ARR_SIZE-1:0][ARR_SIZE-1:0];

    generate
        
        for (genvar i=0;i<ARR_SIZE;i++) begin // generates rows of elements
            for (genvar j=0;j<ARR_SIZE;j++) begin // generate each row of elements
                
                // Types of elements
                //  1) Corner Elements:
                //      1) Top-left corner
                //      2) Top-right corner - handled in top row scenario
                //      3) Bottom-left corner - handled in bottom row scenario
                //      4) Bottom right corner - handled in bottom row scenario
                //  2) Edge elements
                //      1) 1st row of elements
                //      2) 1st column of elements
                //      3) last row of elements - handled by other elements
                //      4) last column of elements  - handled by other elements
                //  3) other elements
                // total of 4 different types of elements to be coded


                if(i==0 && j==0) begin //top-left corner element
                    PE pe_instance(
                        .clk(clk)
                        .rst(rst)
                        .i_mode(i_mode)
                        .i_top(vertical_input[i*VERTICAL_BW+VERTICAL_BW-1:i*VERTICAL_BW])
                        .i_left(horizontal_input[i*HORIZONTAL_BW+HORIZONTAL_BW-1:i*HORIZONTAL_BW])
                        .o_bot(vertical_wires[i][j])
                        .o_right(horizontal_wires[i][j])
                    );

                end

                if(i==0 && j!=0) begin //Top elements
                    PE pe_instance(
                        .clk(clk)
                        .rst(rst)
                        .i_mode(i_mode)
                        .i_top(vertical_input[i*VERTICAL_BW+VERTICAL_BW-1:i*VERTICAL_BW])
                        .i_left(horizontal_wires[i][j-1])
                        .o_bot(vertical_wires[i][j])
                        .o_right(horizontal_wires[i][j])
                    );
                end

                if(i!=0 && j==0) begin //Left elements
                    PE pe_instance(
                        .clk(clk)
                        .rst(rst)
                        .i_mode(i_mode)
                        .i_top(vertical_wires[i-1][j])
                        .i_left(horizontal_input[i*HORIZONTAL_BW+HORIZONTAL_BW-1:i*HORIZONTAL_BW])
                        .o_bot(vertical_wires[i][j])
                        .o_right(horizontal_wires[i][j])
                    );
                end

                if(i!=0 && j!=0) begin //Other elements
                    PE pe_instance(
                        .clk(clk)
                        .rst(rst)
                        .i_mode(i_mode)
                        .i_top(vertical_wires[i-1][j])
                        .i_left(horizontal_wires[i][j-1])
                        .o_bot(vertical_wires[i][j])
                        .o_right(horizontal_wires[i][j])
                    );
                end

            end

        end

    endgenerate

    // Creating accumulator:
    // Consists of ARR_SIZE number of adders. This is the output of the MMU
    
    generate

        for(genvar k = 0; k<ARR_SIZE; k++) begin
            
            adder accumulator(
                .clk(clk),
                .rst(rst),
                .A(accumulated_val[k*HORIZONTAL_BW+HORIZONTAL_BW-1:k*HORIZONTAL_BW]),
                .B(horizontal_wires[ARR_SIZE-1][k]),
                .O(accumulated_val[k*HORIZONTAL_BW+HORIZONTAL_BW-1:k*HORIZONTAL_BW])
            )

        end

    endgenerate

endmodule