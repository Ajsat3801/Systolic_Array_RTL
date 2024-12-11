`timescale 1ns / 1ps

module bfp32_adder_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] A;
    reg [31:0] B;

    // Output
    wire [31:0] O;

    // Instantiate the Unit Under Test (UUT)
    bfp32_adder uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .O(O)
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
        A = 32'b0;
        B = 32'b0;

        // Apply reset
        #10 rst = 0;

        // Test 1: Normal addition
        A = 32'b01000001000000000000000000000000; // 2.0 in BFP32
        B = 32'b01000010000000000000000000000000; // 3.0 in BFP32
        #20;

        // Test 2: Addition with zero
        A = 32'b01000001000000000000000000000000; // 2.0 in BFP32
        B = 32'b00000000000000000000000000000000; // 0.0 in BFP32
        #20;

        // Test 3: Addition with NaN
        A = 32'b01111111100000000000000000000001; // NaN in BFP32
        B = 32'b01000010000000000000000000000000; // 3.0 in BFP32
        #20;

        // Test 4: Addition with infinity
        A = 32'b01111111100000000000000000000000; // Infinity in BFP32
        B = 32'b01000010000000000000000000000000; // 3.0 in BFP32
        #20;

        // Test 5: Addition of two negatives
        A = 32'b11000001000000000000000000000000; // -2.0 in BFP32
        B = 32'b11000010000000000000000000000000; // -3.0 in BFP32
        #20;

        // Test 6: Addition resulting in denormalized number
        A = 32'b00000000100000000000000000000000; // Small value in BFP32
        B = 32'b00000000100000000000000000000000; // Small value in BFP32
        #20;

        // Test 7: Addition resulting in overflow
        A = 32'b01111111011111111111111111111111; // Large value in BFP32
        B = 32'b01000000000000000000000000000000; // 2.0 in BFP32
        #20;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b rst=%b A=%h B=%h O=%h",
                 clk, rst, A, B, O);
    end

endmodule
