module Output_buffer #(

)(
    input clk,
    input [31:0] data,
    input [3:0] op_buf_addr_for_store,
    input [3:0] op_buf_addr_for_external_comm,
    input op_buffer_instr_for_sending_data,
    output reg [31:0] res_to_external
);

    always @(posedge clk) begin
        if(op_buffer_instr_for_sending_data==1'b1)begin
            
        end

    end





endmodule