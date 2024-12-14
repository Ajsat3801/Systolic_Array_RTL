// Testbench for MAC
`timescale 1ns / 1ps

module MAC_tb;

    // Parameters
    parameter ARR_SIZE = 4;
    parameter VERTICAL_BW = 32;
    parameter HORIZONTAL_BW = 16;
    parameter ACC_SIZE = 64;

    // Inputs
    reg clk;
    reg i_mode;
    reg rst;
    reg [HORIZONTAL_BW*ARR_SIZE-1:0] vertical_input;
    reg [HORIZONTAL_BW*ARR_SIZE-1:0] horizontal_input;

    // Outputs
    wire [ARR_SIZE*VERTICAL_BW-1:0] accumulator_op;

    // Instantiate the Unit Under Test (UUT)
    MAC #(ARR_SIZE, VERTICAL_BW, HORIZONTAL_BW, ACC_SIZE) uut (
        .clk(clk),
        .i_mode(i_mode),
        .rst(rst),
        .vertical_input(vertical_input),
        .horizontal_input(horizontal_input),
        .MAC_OP(accumulator_op)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        i_mode = 0;
        vertical_input = 0;
        horizontal_input = 0;

        // Apply reset
        #10 rst = 0;

        // Test 1: Normal operation with random inputs
        vertical_input = {16'd1, 16'd2, 16'd3, 16'd4};
        horizontal_input = {16'd5, 16'd6, 16'd7, 16'd8};
        i_mode = 1; // Enable mode
        #20;

        // Test 2: Reset during operation
        rst = 1;
        #10 rst = 0;
        #20;

        // Test 3: Larger inputs
        vertical_input = {16'd10, 16'd20, 16'd30, 16'd40};
        horizontal_input = {16'd50, 16'd60, 16'd70, 16'd80};
        #20;

        // Test 4: Edge case - all zeros
        vertical_input = 0;
        horizontal_input = 0;
        #20;

        // Test 5: Edge case - maximum values
        vertical_input = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF};
        horizontal_input = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF};
        #20;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b rst=%b i_mode=%b vertical_input=%h horizontal_input=%h accumulator_op=%h",
                 clk, rst, i_mode, vertical_input, horizontal_input, accumulator_op);
    end

endmodule