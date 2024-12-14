`timescale 1ns / 1ps

module Controller_tb;

    // Inputs
    reg clk;
    reg [63:0] instruction;

    // Outputs
    wire [13:0] inp_buf_addr;
    wire [31:0] inp_buf_data;
    wire [13:0] wt_buf_addr;
    wire [31:0] wt_buf_data;
    wire [3:0] acc_to_op_buf_addr;
    wire acc_result_to_op_buf;
    wire [3:0] out_buf_addr;
    wire op_buffer_instr_for_sending_data;
    wire instr_for_accum_to_reset;
    wire [1:0] state_signal;
    wire i_mode;

    // Instantiate the Unit Under Test (UUT)
    controller uut (
        .clk(clk),
        .instruction(instruction),
        .inp_buf_addr(inp_buf_addr),
        .inp_buf_data(inp_buf_data),
        .wt_buf_addr(wt_buf_addr),
        .wt_buf_data(wt_buf_data),
        .acc_to_op_buf_addr(acc_to_op_buf_addr),
        .acc_result_to_op_buf(acc_result_to_op_buf),
        .op_buffer_instr_for_sending_data(op_buffer_instr_for_sending_data),
        .instr_for_accum_to_reset(instr_for_accum_to_reset),
        .state_signal(state_signal),
        .i_mode(i_mode)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        instruction = 64'b0;

        // Test 1: No instruction
        #10 instruction = 64'b0; // No operation
        #10;

        // Test 2: MAC operation
        instruction = {59'b0, 5'b00001};
        #10;

        // Test 3: Send weights
        instruction = {59'b0, 5'b00010};
        #10;

        // Test 4: Store output
        instruction = {48'b0, 16'h0003, 5'b00011};
        #10;

        // Test 5: Receive inputs
        instruction = {32'hDEADBEEF, 16'h0001, 5'b00100};
        #10;

        // Test 6: Receive weights
        instruction = {32'hCAFEBABE, 16'h0002, 5'b00101};
        #10;

        // Test 7: Transmit output
        instruction = {48'b0, 16'h0004, 5'b00110};
        #10;

        // Test 8: Reset accumulator
        instruction = {59'b0, 5'b00111};
        #10;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b instruction=%h inp_buf_addr=%h inp_buf_data=%h wt_buf_addr=%h wt_buf_data=%h acc_to_op_buf_addr=%h acc_result_to_op_buf=%b out_buf_addr=%h op_buffer_instr_for_sending_data=%b instr_for_accum_to_reset=%b state_signal=%b i_mode=%b",
                 clk, instruction, inp_buf_addr, inp_buf_data, wt_buf_addr, wt_buf_data, acc_to_op_buf_addr, acc_result_to_op_buf, out_buf_addr, op_buffer_instr_for_sending_data, instr_for_accum_to_reset, state_signal, i_mode);
    end

endmodule
