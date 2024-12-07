module controller #(
    
)(
    input clk,
    input [63:0] instruction,
    output reg [14:0] inp_buf_addr,
    output reg [31:0] inp_buf_data,
    output reg [14:0] wt_buf_addr,
    output reg [31:0] wt_buf_data,
    output reg [3:0] acc_to_op_buf_addr,
    output reg acc_result_to_op_buf,
    output reg [3:0] acc_to_op_buf_addr
);

// Internal registers
reg [4:0] opcode;
reg [14:0] address;
reg [31:0] data;

//Instruction Decode    
always @(posedge clk) begin
    opcode = instruction[63:59]; // 5-bit opcode
    address = instruction[58:43]; // 16-bit address
    data = instruction[42:27]; // 16-bit data

    //Initialisation
    inp_buf_addr = 15'b0;
    inp_buf_data = 32'b0;
    wt_buf_addr = 15'b0;
    wt_buf_data = 32'b0;
    acc_to_op_buf_addr = 4'b0;
    acc_result_to_op_buf = 1'b0;
    out_buf_addr = 4'b0;

    // Opcode based decode
    case (opcode)
        5'b00000: begin 
            //No instruction received
        end
        5'b11111: begin 
            //NOP
        end   
        5'b00001: begin // MAC
            inp_buf_addr = address; // Input buffer address
        end
        5'b00010: begin // Send weights
            wt_buf_addr = address; // Source address in weight buffer
        end
        5'b00011: begin // Store Output
            acc_to_op_buf_addr = address[3:0]; // Destination in output buffer
            acc_result_to_op_buf = 1'b1; // Send accumulator result
        end
        5'b00100: begin // Receive inputs
            inp_buf_addr = address; // Destination address in input buffer
            inp_buf_data = data; // Data to be stored in input buffer
        end
        5'b00101: begin // Receive weights
            wt_buf_addr = address; // Destination address in weight buffer
            wt_buf_data = data; // Data to be stored in weight buffer
        end
        5'b00110: begin // Transmit output
            out_buf_addr = address[3:0]; // Source address in output buffer
        end
        default: begin
            //Unknown Opcode,do nothing
        end
    endcase
end

endmodule
