module Output_buffer #(

)(
    input clk,
    input [31:0] data,
    input [3:0] op_buf_addr_for_store,
    input [3:0] op_buf_addr_for_external_comm,
    output reg [31:0] res_to_external
);
endmodule