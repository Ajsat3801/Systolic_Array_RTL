module controller #(
    
)(
    input clk
    input [63:0] instruction
    output reg [15:0] inp_buf_addr
    output reg [15:0] inp_buf_data
    output reg [15:0] wt_buf_addr
    output reg [15:0] wt_buf_data
    output reg [3:0] acc_to_op_buf_addr
    output reg acc_result_to_op_buf
    output reg [3:0] acc_to_op_buf_addr
);
endmodule