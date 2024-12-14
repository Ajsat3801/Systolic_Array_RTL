`timescale 1ns / 1ps

module instruction_buffer_tb;

    // Inputs
    reg clk;
    reg rst;
    reg external_clk;
    reg [63:0] interface_input;

    // Outputs
    wire [63:0] instr_to_controller;
    wire buffer_full;

    // Instantiate the Unit Under Test (UUT)
    instruction_buffer uut (
        .clk(clk),
        .rst(rst),
        .external_clk(external_clk),
        .interface_input(interface_input),
        .instr_to_controller(instr_to_controller),
        .buffer_full(buffer_full)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        external_clk = 0;
        forever #7 external_clk = ~external_clk; // 14ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        interface_input = 64'b0;

        // Apply reset
        #10 rst = 0;

        // Test 1: Add a single instruction
        interface_input = 64'hDEADBEEFCAFEBABE;
        #14;

        // Test 2: Add multiple instructions
        interface_input = 64'h1122334455667788;
        #14;
        interface_input = 64'hAABBCCDDEEFF0011;
        #14;

        // Test 3: Verify buffer outputs instructions
        #20;

        // Test 4: Fill the buffer to full capacity
        repeat(64) begin
            interface_input = $random;
            #14;
        end

        // Test 5: Verify `buffer_full` signal
        #10;

        // Test 6: Reset the buffer during operation
        rst = 1;
        #10;
        rst = 0;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b external_clk=%b rst=%b interface_input=%h instr_to_controller=%h buffer_full=%b",
                 clk, external_clk, rst, interface_input, instr_to_controller, buffer_full);
    end

endmodule
