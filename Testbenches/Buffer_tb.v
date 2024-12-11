`timescale 1ns / 1ps

module Buffer_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] data_in;
    reg [13:0] addr;
    reg [1:0] state;

    // Outputs
    wire [63:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    Buffer uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .addr(addr),
        .state(state),
        .data_out(data_out)
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
        data_in = 32'b0;
        addr = 14'b0;
        state = 2'b00;

        // Apply reset
        #10 rst = 0;

        // Test 1: Store data into the buffer
        state = 2'b01; // Store state
        data_in = 32'hDEADBEEF; // First data
        #10;
        data_in = 32'hCAFEBABE; // Second data
        #10;
        state = 2'b00; // No operation
        #10;

        // Test 2: Stream data from the buffer
        state = 2'b10; // Stream state
        #20;
        state = 2'b00; // No operation
        #10;

        // Test 3: Reset the buffer
        rst = 1;
        #10 rst = 0;

        // Test 4: Store and stream in quick succession
        state = 2'b01; // Store state
        data_in = 32'hAABBCCDD;
        #10;
        state = 2'b10; // Stream state
        #20;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b rst=%b state=%b data_in=%h data_out=%h",
                 clk, rst, state, data_in, data_out);
    end

endmodule
