`timescale 1ns / 1ps

module bfp16_mult_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [15:0] A;
    reg [15:0] B;

    // Output
    wire [15:0] O;

    // Instantiate the Unit Under Test (UUT)
    bfp16_mult uut (
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
        A = 16'b0;
        B = 16'b0;

        // Apply reset
        #10 rst = 0;

        // Test 1: Normal multiplication
        A = 16'b0100000100000000; // 2.0 in BFP16
        B = 16'b0100001000000000; // 3.0 in BFP16
        #20;

        // Test 2: Multiplication with zero
        A = 16'b0100000100000000; // 2.0 in BFP16
        B = 16'b0000000000000000; // 0.0 in BFP16
        #20;

        // Test 3: Multiplication with NaN
        A = 16'b0111111110000001; // NaN in BFP16
        B = 16'b0100001000000000; // 3.0 in BFP16
        #20;

        // Test 4: Multiplication with infinity
        A = 16'b0111111110000000; // Infinity in BFP16
        B = 16'b0100001000000000; // 3.0 in BFP16
        #20;

        // Test 5: Multiplication of two negatives
        A = 16'b1100000100000000; // -2.0 in BFP16
        B = 16'b1100001000000000; // -3.0 in BFP16
        #20;

        // Test 6: Multiplication resulting in denormalized number
        A = 16'b0000000100000000; // Small value in BFP16
        B = 16'b0000000100000000; // Small value in BFP16
        #20;

        // Test 7: Multiplication resulting in overflow
        A = 16'b0111111101111111; // Large value in BFP16
        B = 16'b0100000000000000; // 2.0 in BFP16
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
