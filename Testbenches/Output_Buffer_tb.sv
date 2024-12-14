`timescale 1ns / 1ps

module Output_buffer_tb;

// Inputs
reg clk;
reg rst;
reg [31:0] data;
reg [3:0] op_buf_addr_for_store;
reg [3:0] op_buf_addr_for_external_comm;
reg op_buffer_instr_for_storing_data;
reg op_buffer_instr_for_sending_data;

// Outputs
wire [31:0] res_to_external;

// Instantiate the DUT (Device Under Test)
Output_buffer uut (
    .clk(clk),
    .rst(rst),
    .data(data),
    .op_buf_addr_for_store(op_buf_addr_for_store),
    .op_buf_addr_for_external_comm(op_buf_addr_for_external_comm),
    .op_buffer_instr_for_storing_data(op_buffer_instr_for_storing_data),
    .op_buffer_instr_for_sending_data(op_buffer_instr_for_sending_data),
    .res_to_external(res_to_external)
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
    data = 32'b0;
    op_buf_addr_for_store = 4'b0;
    op_buf_addr_for_external_comm = 4'b0;
    op_buffer_instr_for_storing_data = 0;
    op_buffer_instr_for_sending_data = 0;

    // Apply reset
    #10;
    rst = 0;

    // Test 1: Check reset behavior
    #10;
    if (res_to_external !== 32'b0) begin
        $display("Test 1 Failed: Reset behavior incorrect.");
    end else begin
        $display("Test 1 Passed: Reset behavior correct.");
    end

    // Test 2: Store data into buffer
    op_buf_addr_for_store = 4'd3;  // Store at address 3
    data = 32'hDEADBEEF;           // Test data
    op_buffer_instr_for_storing_data = 1;
    #10;
    op_buffer_instr_for_storing_data = 0; // Turn off store signal
    #10;

    // Test 3: Retrieve data from buffer
    op_buf_addr_for_external_comm = 4'd3; // Retrieve from address 3
    op_buffer_instr_for_sending_data = 1;
    #10;
    op_buffer_instr_for_sending_data = 0; // Turn off send signal

    if (res_to_external !== 32'hDEADBEEF) begin
        $display("Test 3 Failed: Data retrieval incorrect. Got: %h", res_to_external);
    end else begin
        $display("Test 3 Passed: Data retrieval correct.");
    end

    // Test 4: Overwrite data
    op_buf_addr_for_store = 4'd3;  // Same address as before
    data = 32'hCAFEBABE;           // New test data
    op_buffer_instr_for_storing_data = 1;
    #10;
    op_buffer_instr_for_storing_data = 0; // Turn off store signal
    #10;

    // Retrieve the overwritten data
    op_buf_addr_for_external_comm = 4'd3; // Same address
    op_buffer_instr_for_sending_data = 1;
    #10;
    op_buffer_instr_for_sending_data = 0; // Turn off send signal

    if (res_to_external !== 32'hCAFEBABE) begin
        $display("Test 4 Failed: Overwrite behavior incorrect. Got: %h", res_to_external);
    end else begin
        $display("Test 4 Passed: Overwrite behavior correct.");
    end

    // Test 5: Stress test (write to multiple locations)
    for (int i = 0; i < 16; i = i + 1) begin
        op_buf_addr_for_store = i[3:0];    // Store to address `i`
        data = i * 32'h11111111;          // Unique test data
        op_buffer_instr_for_storing_data = 1;
        #10;
        op_buffer_instr_for_storing_data = 0;
        #10;
    end

    // Verify stored data
    for (int i = 0; i < 16; i = i + 1) begin
        op_buf_addr_for_external_comm = i[3:0]; // Read from address `i`
        op_buffer_instr_for_sending_data = 1;
        #10;
        op_buffer_instr_for_sending_data = 0;
        #10;

        if (res_to_external !== i * 32'h11111111) begin
            $display("Test 5 Failed at address %d: Expected: %h, Got: %h", i, i * 32'h11111111, res_to_external);
        end else begin
            $display("Test 5 Passed for address %d: Data correct.", i);
        end
    end

    $display("All tests completed.");
    $stop;
end

endmodule
