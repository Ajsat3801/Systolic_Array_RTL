`timescale 1ns/1ps


module MAC #(
    parameter ARR_SIZE = 4, // set to 128 during final synthesis 
    parameter VERTICAL_BW = 32,
    parameter HORIZONTAL_BW = 16,
    parameter ACC_SIZE = 64
) (
    input clk,
    input i_mode,
    input rst,
    input [HORIZONTAL_BW * ARR_SIZE - 1 : 0] vertical_input,
    input [HORIZONTAL_BW * ARR_SIZE - 1 : 0] horizontal_input,
    output reg [ARR_SIZE * VERTICAL_BW - 1 : 0] MAC_OP
);

    wire [HORIZONTAL_BW-1:0]horizontal_wires[ARR_SIZE-1:0][ARR_SIZE-1:0];
    wire [VERTICAL_BW-1:0]vertical_wires[ARR_SIZE-1:0][ARR_SIZE-1:0];
    wire [ARR_SIZE * VERTICAL_BW - 1 : 0] op_wire;

    generate
        genvar i;
        genvar j;
        for (i=0; i<ARR_SIZE; i=i+1) begin // generates rows of elements
            for (j=0; j<ARR_SIZE; j=j+1) begin // generate each row of elements
                
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
                    PE pe_instance_tlcorner(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top({16'b0,vertical_input[ (j+1) * HORIZONTAL_BW - 1 : j * HORIZONTAL_BW]}),
                        .i_left(horizontal_input[ (i+1) * HORIZONTAL_BW - 1 : i * HORIZONTAL_BW]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );

                end

                else if(i==0 && j!=0) begin //Top elements
                    PE pe_instance_top(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top({16'b0,vertical_input[(j+1) * HORIZONTAL_BW - 1 : j * HORIZONTAL_BW]}),
                        .i_left(horizontal_wires[i][j-1]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

                else if(i!=0 && j==0) begin //Left elements
                    PE pe_instance_left(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top(vertical_wires[i-1][j]),
                        .i_left(horizontal_input[(i+1) * HORIZONTAL_BW - 1 : i * HORIZONTAL_BW]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

                else if (i==ARR_SIZE-1 && j==0) begin // Bottom-Left element
                    PE pe_instance_blcorner(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top(vertical_wires[i-1][j]),
                        .i_left(horizontal_input[(i+1) * HORIZONTAL_BW - 1 : i * HORIZONTAL_BW]),
                        .o_bot(op_wire[(j+1)*HORIZONTAL_BW:j*HORIZONTAL_BW]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

                else if (i==ARR_SIZE-1 && j!=0) begin // Bottom Row elements element
                    PE pe_instance_bottom(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top(vertical_wires[i-1][j]),
                        .i_left(horizontal_wires[i][j-1]),
                        .o_bot(op_wire[(j+1)*HORIZONTAL_BW:j*HORIZONTAL_BW]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

                else if(i!=0 && j!=0) begin //Other elements
                    PE pe_instance_middle(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top(vertical_wires[i-1][j]),
                        .i_left(horizontal_wires[i][j-1]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

            end

        end

    endgenerate

    always @(posedge clk) begin
        MAC_OP <= op_wire;
    end

endmodule