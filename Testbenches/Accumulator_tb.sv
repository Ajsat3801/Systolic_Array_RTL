`timescale 1ns / 1ps

module Accumulator_tb;

    // Parameters
    parameter ARR_SIZE = 4;
    parameter VERTICAL_BW = 32;

    // Inputs
    reg clk;
    reg rst;
    reg [3:0] op_buffer_address;
    reg [ARR_SIZE*VERTICAL_BW-1:0] accumulated_val;
    reg acc_reset;
    reg store_output;

    // Outputs
    wire [31:0] output_data;
    wire [3:0] output_buffer_addr;
    wire output_buffer_enable;

    // Instantiate the Unit Under Test (UUT)
    Accumulator #(ARR_SIZE, VERTICAL_BW) uut (
        .clk(clk),
        .rst(rst),
        .op_buffer_address(op_buffer_address),
        .accumulated_val(accumulated_val),
        .acc_reset(acc_reset),
        .store_output(store_output),
        .output_data(output_data),
        .output_buffer_addr(output_buffer_addr),
        .output_buffer_enable(output_buffer_enable)
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
        acc_reset = 0;
        store_output = 0;
        op_buffer_address = 4'b0000;
        accumulated_val = 0;

        // Wait for global reset
        #15;
        rst = 0;

        // Test 1: Apply values to accumulated_val and observe output
        accumulated_val = {32'd10, 32'd20, 32'd30, 32'd40};
      //  acc_reset = 1;
        #10;
       // acc_reset = 0;
        accumulated_val = {32'd5, 32'd15, 32'd25, 32'd35};

        // Test 2: Enable store_output and check output values
        store_output = 1;
        op_buffer_address = 4'b1010;
        #10;
       // store_output = 0;

        // Test 3: Reset the module and ensure accumulator_op is cleared
      //  rst = 1;
       #10;
      //  rst = 0;

        // Test 4: Accumulate new values
        accumulated_val = {32'd5, 32'd15, 32'd25, 32'd35};
        #20;

        // Test 5: Observe output after multiple clock cycles
        store_output = 1;
        op_buffer_address = 4'b1100;
        #10;
        store_output = 0;

        // End simulation
        #50;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b rst=%b acc_reset=%b store_output=%b op_buffer_address=%h accumulated_val=%h output_data=%h output_buffer_addr=%h output_buffer_enable=%b",
                 clk, rst, acc_reset, store_output, op_buffer_address, accumulated_val, output_data, output_buffer_addr, output_buffer_enable);
    end

endmodule
