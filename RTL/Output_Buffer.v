`timescale 1ns/1ps

module Output_buffer #(

)(
    input clk,
    input rst,
    input [31:0] data,
    input [3:0] op_buf_addr_for_store,
    input [3:0] op_buf_addr_for_external_comm,
    input op_buffer_instr_for_storing_data,
    input op_buffer_instr_for_sending_data,
    output reg [31:0] res_to_external
);

    reg [31:0] buf_data [0:15];

    always @(posedge clk) begin
        
        if(rst==1) begin
            for(integer i=0;i<16;i=i+1) begin
                buf_data[i] <= 32'b0;
            end
        end
        else begin

            if(op_buffer_instr_for_sending_data==1'b1) begin
                res_to_external <= buf_data[op_buf_addr_for_external_comm];
            end
            if(op_buffer_instr_for_storing_data==1'b1) begin
                buf_data[op_buf_addr_for_store] <= data;
            end
        end
    end

endmodule