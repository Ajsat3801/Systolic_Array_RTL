`timescale 1ns / 1ps

module PE_tb;

// Parameters
parameter ADD_BW = 32;
parameter MUL_BW = 16;

// Inputs
reg clk;
reg rst;
reg i_mode;
reg [ADD_BW-1:0] i_top;
reg [MUL_BW-1:0] i_left;

// Outputs
wire [ADD_BW-1:0] o_bot;
wire [MUL_BW-1:0] o_right;

// Instantiate the DUT (Device Under Test)
PE #(
    .ADD_BW(ADD_BW),
    .MUL_BW(MUL_BW)
) uut (
    .clk(clk),
    .rst(rst),
    .i_mode(i_mode),
    .i_top(i_top),
    .i_left(i_left),
    .o_bot(o_bot),
    .o_right(o_right)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
end

// Test sequence
initial begin
    // Initialize inputs
    rst = 1;
    i_mode = 0;
    i_top = 0;
    i_left = 0;

    // Apply reset
    #10;
    rst = 0;
    #10;
    rst = 1;

    // Test 1: Load mode (i_mode = 0)
    i_mode = 0;
    i_top = 32'hABCD1234; // Load lower 16 bits into r_buffer
    i_left = 16'h5678;    // Value to propagate to o_right
    #10;
    if (o_bot !== 32'h00001234 || o_right !== 16'h5678) begin
        $display("Test 1 Failed: Load mode output incorrect.");
    end else begin
        $display("Test 1 Passed: Load mode output correct.");
    end

    // Test 2: Accumulate mode (i_mode = 1)
    i_mode = 1;
    i_top = 32'h11111111; // Value for accumulation
    i_left = 16'h0002;    // Multiplier input
    #10;
    if (o_bot !== 32'h22222222) begin // Expected: i_top + (r_buffer * i_left) << 16
        $display("Test 2 Failed: Accumulate mode output incorrect. Got: %h", o_bot);
    end else begin
        $display("Test 2 Passed: Accumulate mode output correct.");
    end
    

    // Test 3: Reset behavior
    rst = 0; // Apply reset
    #10;
    rst = 1;
    if (o_bot !== 32'b0 || o_right !== 16'b0) begin
        $display("Test 3 Failed: Reset behavior incorrect.");
    end else begin
        $display("Test 3 Passed: Reset behavior correct.");
    end

    // Test 4: Stress test
    i_mode = 1;
    repeat (10) begin
        i_top = $random;
        i_left = $random % (1 << MUL_BW); // Limit to 16-bit value
        #10;
        $display("Stress Test Input: i_top = %h, i_left = %h, o_bot = %h, o_right = %h", i_top, i_left, o_bot, o_right);
    end

    // Test 5: Edge case
    i_mode = 1;
    i_top = 32'hFFFFFFFF; // Max value for i_top
    i_left = 16'hFFFF;    // Max value for i_left
    #10;
    if (o_bot !== 32'hFFFFFFFF) begin // Expect overflow handling
        $display("Test 5 Failed: Edge case handling incorrect.");
    end else begin
        $display("Test 5 Passed: Edge case handled correctly.");
    end

    $display("All tests completed.");
    $stop;
end

endmodule
