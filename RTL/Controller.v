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
    output reg [3:0] acc_to_op_buf_addr,
    output reg op_buffer_instr_for_sending_data,
    output reg instr_for_accum_to_reset,
    output reg [1:0] state_signal //01 for write enable, 10 to start streaming data, 00 NOP
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
    op_buffer_instr_for_sending_data = 1'b0;
    instr_for_accum_to_reset = 1'b0;
    state_signal = 2'b0;

    // Opcode based decode
    case (opcode)
        5'b00000: begin 
            //No instruction received
        end
        5'b11111: begin 
            //NOP
        end   
        5'b00001: begin // MAC
            state_signal <= 2b'10; //Command to start streaming the inputs
        end
        5'b00010: begin // Send weights
            state_signal <= 2b'10; //Command to start streaming the
        end
        5'b00011: begin // Store Output
            state_signal <= 2b'01; //Write enble
            acc_to_op_buf_addr <= address[3:0]; // Destination in output buffer
            acc_result_to_op_buf <= 1'b1; // Send accumulator result
        end
        5'b00100: begin // Receive inputs
            state_signal <= 2b'01; //Write enble
            inp_buf_addr <= address; // Destination address in input buffer
            inp_buf_data <= data; // Data to be stored in input buffer
        end
        5'b00101: begin // Receive weights
            state_signal <= 2b'01; //Write enble
            wt_buf_addr <= address; // Destination address in weight buffer
            wt_buf_data <= data; // Data to be stored in weight buffer
        end
        5'b00110: begin // Transmit output
            state_signal <= 2b'01; //Write enble
            out_buf_addr <= address[3:0]; // Source address in output buffer
            op_buffer_instr_for_sending_data <= 1'b1;
        end
        5'b00111: begin // Instruct the accumulator to send a copy of data to the output buffer
            state_signal <= 2b'01; //Write enble
            instr_for_accum_to_reset <= 1'b1; 
        end       
        default: begin
            //Unknown Opcode,do nothing
        end
    endcase
end

endmodule
