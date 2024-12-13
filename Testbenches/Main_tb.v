`timescale 1ns / 1ps

module accelerator_tb;

// Parameters
parameter ARR_SIZE = 4;

// Inputs
reg clk;
reg rst;
reg external_clk;
reg [63:0] accelerator_input;

// Outputs
wire [31:0] accelerator_output;
wire buffer_full;

// Instantiate the DUT (Device Under Test)
accelerator #(
    .ARR_SIZE(ARR_SIZE)
) uut (
    .clk(clk),
    .rst(rst),
    .external_clk(external_clk),
    .accelerator_input(accelerator_input),
    .accelerator_output(accelerator_output),
    .buffer_full(buffer_full)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
end

initial begin
    external_clk = 0;
    forever #10 external_clk = ~external_clk; // 50 MHz clock
end

// Test sequence
initial begin
    // Initialize inputs
    rst = 1;
    accelerator_input = 0;

    // Reset pulse
    #15;
    rst = 0;

    // Test 1: Check reset behavior
    #10;
    if (accelerator_output !== 0 || buffer_full !== 0) begin
        $display("Test 1 Failed: Reset behavior incorrect.");
    end else begin
        $display("Test 1 Passed: Reset behavior correct.");
    end

    // Test 2: Feed inputs and check outputs
    accelerator_input = 64'hFFFFFFFFFFFFFFFF; // Max input
    #10;
    if (buffer_full === 1) begin
        $display("Test 2 Passed: Buffer correctly indicates full.");
    end else begin
        $display("Test 2 Failed: Buffer full signal not as expected.");
    end

    // Test 3: Corner case input (minimum input)
    accelerator_input = 64'h0; // Min input
    #10;
    if (accelerator_output === 0) begin
        $display("Test 3 Passed: Minimum input handled correctly.");
    end else begin
        $display("Test 3 Failed: Unexpected output for minimum input.");
    end

    // Test 4: Randomized input
    repeat (5) begin
        accelerator_input = $random;
        #10;
        $display("Random Test Input: %h, Output: %h", accelerator_input, accelerator_output);
    end

    // Test 5: Stress test
    accelerator_input = 64'hAAAAAAAAAAAAAAAA; // Alternating pattern
    #10;
    accelerator_input = 64'h5555555555555555; // Inverted alternating pattern
    #10;

    // Finalize
    $display("Test completed.");
    $stop;
end

endmodule
