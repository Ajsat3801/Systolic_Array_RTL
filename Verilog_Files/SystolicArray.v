`timescale 1ns / 1ps

module bfp16_mult(clk, rst, A, B, O);

  input clk;
  input rst;
  input [15:0] A, B;
  output reg [15:0] O;

  wire a_sign;
  wire b_sign;
  wire [7:0] a_exponent;
  wire [7:0] b_exponent;
  wire [7:0] a_mantissa;
  wire [7:0] b_mantissa;
             
  reg o_sign;
  reg [7:0]  o_exponent;
  reg [8:0] o_mantissa;  
	
  reg [15:0] multiplier_a_in;
  reg [15:0] multiplier_b_in;
  wire [15:0] multiplier_out;

  //assign O[15] = o_sign;
  //assign O[14:7] = o_exponent;
  //assign O[6:0] = o_mantissa[6:0];

  assign a_sign = A[15];
  assign a_exponent[7:0] = A[14:7];
  assign a_mantissa[7:0] = {1'b1, A[6:0]};

  assign b_sign = B[15];
  assign b_exponent[7:0] = B[14:7];
  assign b_mantissa[7:0] = {1'b1, B[6:0]};

	gMultiplier M1 (
		.a(multiplier_a_in),
		.b(multiplier_b_in),
		.out(multiplier_out)
	);
	
  assign multiplier_a_in = A; // timing fix - singly cycle
  assign multiplier_b_in = B; // timing fix - single cycle

  //always @ (posedge clk) begin //Multiplication
  always @ (*) begin //Multiplication
	if (rst == 1'b1) begin
		O = 32'd0;
	end else begin
		//If a is NaN return NaN
		if (a_exponent == 255 && a_mantissa != 0) begin
		  o_sign = a_sign;
		  o_exponent = 255;
		  o_mantissa = a_mantissa;
		  O ={o_sign, o_exponent, o_mantissa[6:0]};
			//If b is NaN return NaN
		end else if (b_exponent == 255 && b_mantissa != 0) begin
		  o_sign = b_sign;
		  o_exponent = 255;
		  o_mantissa = b_mantissa;
		  O ={o_sign, o_exponent, o_mantissa[6:0]};
		//If a or b is 0 return 0
		end else if ((a_exponent == 0) && (a_mantissa == 0) || (b_exponent == 0) && (b_mantissa == 0)) begin
		  o_sign = a_sign ^ b_sign;
		  o_exponent = 0;
		  o_mantissa = 0;
		  O ={o_sign, o_exponent, o_mantissa[6:0]};
		//if a or b is inf return inf
		end else if ((a_exponent == 255) || (b_exponent == 255)) begin
		  o_sign = a_sign;
		  o_exponent = 255;
		  o_mantissa = 0;
		  O ={o_sign, o_exponent, o_mantissa[6:0]};
		end else if (A == 'd0 && B == 'd0) begin
		  o_sign = 0;
		  o_exponent = 0;
		  o_mantissa = 0;
		  O ={o_sign, o_exponent, o_mantissa[6:0]};
		end else begin // Passed all corner cases
		  //multiplier_a_in = A;
		  //multiplier_b_in = B;
		  o_sign = multiplier_out[15];
		  o_exponent = multiplier_out[14:7];
		  o_mantissa = multiplier_out[6:0]; 
		  O ={o_sign, o_exponent, o_mantissa[6:0]};
		end
	end
  end
endmodule

module gMultiplier(a, b, out);
  input  [15:0] a, b;
  output [15:0] out;
  wire [15:0] out;
    reg a_sign;
  reg [7:0] a_exponent;
  reg [7:0] a_mantissa;
	reg b_sign;
  reg [7:0] b_exponent;
  reg [7:0] b_mantissa;

  reg o_sign;
  reg [7:0] o_exponent;
  reg [8:0] o_mantissa;

	reg [15:0] product;

  assign out[15] = o_sign;
  assign out[14:7] = o_exponent;
  assign out[6:0] = o_mantissa[6:0];

	reg  [7:0] i_e;
	reg  [15:0] i_m;
	wire [7:0] o_e;
	wire [15:0] o_m;

	multiplication_normaliser norm1
	(
		.in_e(i_e),
		.in_m(i_m),
		.out_e(o_e),
		.out_m(o_m)
	);


  always @ ( * ) begin
		a_sign = a[15];
   
		if(a[14:7] == 0) begin
			a_exponent = 8'b00000001;
			a_mantissa = {1'b0, a[6:0]};
		end else begin
			a_exponent = a[14:7];
			a_mantissa = {1'b1, a[6:0]};
		end
   
		b_sign = b[15];
   
		if(b[14:7] == 0) begin
			b_exponent = 8'b00000001;
			b_mantissa = {1'b0, b[6:0]};
		end else begin
			b_exponent = b[14:7];
			b_mantissa = {1'b1, b[6:0]};
		end
   
    o_sign = a_sign ^ b_sign;
    o_exponent = a_exponent + b_exponent - 127;
    product = a_mantissa * b_mantissa;
    
		// Normalization
    //if(product[13] == 1) begin
    if(product[15] == 1 ) begin // fix
      o_exponent = o_exponent + 1;
      product = product >> 1;
    end else if((product[14] != 1) && (o_exponent != 0)) begin
      i_e = o_exponent;
      i_m = product;
      o_exponent = o_e;
      product = o_m;
    end
    
		o_mantissa = product[14:7];
	end
endmodule

module multiplication_normaliser(in_e, in_m, out_e, out_m);
  input [7:0] in_e;
  input [15:0] in_m;
  output [7:0] out_e;
  output [15:0] out_m;

  wire [7:0] in_e;
  wire [15:0] in_m;
  reg [7:0] out_e;
  reg [15:0] out_m;

  always @ ( * ) begin
	  if (in_m[14:9] == 6'b000001) begin
			out_e = in_e - 5;
			out_m = in_m << 5;
		end else if (in_m[14:10] == 5'b00001) begin
			out_e = in_e - 4;
			out_m = in_m << 4;
		end else if (in_m[14:11] == 4'b0001) begin
			out_e = in_e - 3;
			out_m = in_m << 3;
		end else if (in_m[14:12] == 3'b001) begin
			out_e = in_e - 2;
			out_m = in_m << 2;
		end else if (in_m[14:13] == 2'b01) begin
			out_e = in_e - 1;
			out_m = in_m << 1;
		end else begin
			out_e = in_e;
			out_m = in_m;
		end
  end
endmodule

module bfp32_adder(clk, rst, A, B, O);

  input clk;
  input rst;
  input [31:0] A, B;
  output reg [31:0] O;

  wire a_sign;
  wire b_sign;
  wire [7:0] a_exponent;
  wire [7:0] b_exponent; 
  wire [23:0] a_mantissa; // plus one bit
  wire [23:0] b_mantissa; // plus one bit 
             
  reg o_sign;
  reg [7:0] o_exponent;
  reg [24:0] o_mantissa;  // plus two bits
	
  reg [31:0] adder_a_in;
  reg [31:0] adder_b_in;
  wire [31:0] adder_out;
                   

  assign a_sign = A[31];
  assign a_exponent[7:0] = A[30:23];
  assign a_mantissa[23:0] = {1'b1, A[22:0]};
  assign b_sign = B[31];
  assign b_exponent[7:0] = B[30:23];
  assign b_mantissa[23:0] = {1'b1, B[22:0]};

  generalAdder gAdder (
    .a(adder_a_in),
    .b(adder_b_in),
    .out(adder_out)
  );

  assign adder_a_in = A;
  assign adder_b_in = B;
  
  //covers corner cases and uses general adder logic
  //always @ ( posedge clk ) begin
  always @ ( * ) begin
	if (rst == 1'b1) begin
		O = 32'd0;
	end else begin
		//If a is NaN or b is zero return a
		if ((a_exponent == 255 && a_mantissa[22:0] != 0) || (b_exponent == 0) && (b_mantissa[22:0] == 0)) begin
			o_sign = a_sign;
			o_exponent = a_exponent;
			o_mantissa = a_mantissa;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		//If b is NaN or a is zero return b
		end else if ((b_exponent == 255 && b_mantissa[22:0] != 0) || (a_exponent == 0) && (a_mantissa[22:0] == 0)) begin
			o_sign = b_sign;
			o_exponent = b_exponent;
			o_mantissa = b_mantissa;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		//if a and b is inf return inf
		end else if ((a_exponent == 255) || (b_exponent == 255)) begin
			o_sign = a_sign ^ b_sign;
			o_exponent = 255;
			o_mantissa = 0;
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end else begin // Passed all corner cases
			//adder_a_in = A;
			//adder_b_in = B;
			o_sign = adder_out[31];
			o_exponent = adder_out[30:23];
			o_mantissa = adder_out[22:0];
			O = {o_sign, o_exponent, o_mantissa[22:0]};
		end
	end
  end        
endmodule

//general adder logic whenever the inputs change
module generalAdder(a, b, out);
  input [31:0] a, b;
  output [31:0] out;   

  wire [31:0] out;
  
  reg a_sign;
  reg b_sign;
  reg [7:0] a_exponent;
  reg [7:0] b_exponent;
  reg [23:0] a_mantissa;
  reg [23:0] b_mantissa;   
  
  reg o_sign;
  reg [7:0] o_exponent;
  reg [24:0] o_mantissa; 


  reg [7:0] diff;
  reg [23:0] tmp_mantissa;

  reg [7:0] i_e;
  reg [24:0] i_m;
  wire [7:0] o_e;
  wire [24:0] o_m;

                       
  addition_normaliser norm1(
    .in_e(i_e),
    .in_m(i_m),
    .out_e(o_e),
    .out_m(o_m)
  );

  assign out[31] = o_sign;
  assign out[30:23] = o_exponent;
  assign out[22:0] = o_mantissa[22:0];

  always @ (*) begin
  
	  a_sign = a[31];
     
	  if(a[30:23] == 0) begin
		  a_exponent = 8'b00000001;
		  a_mantissa = {1'b0, a[22:0]};
	  end else begin
		  a_exponent = a[30:23];
		  a_mantissa = {1'b1, a[22:0]};
	  end
     
	  b_sign = b[31];
     
	  if(b[30:23] == 0) begin
		  b_exponent = 8'b00000001;
		  b_mantissa = {1'b0, b[22:0]};
	  end else begin
		  b_exponent = b[30:23];
		  b_mantissa = {1'b1, b[22:0]};
	  end
     
    if (a_exponent == b_exponent) begin // Equal exponents
      	o_exponent = a_exponent;
      	if (a_sign == b_sign) begin // Equal signs = add
        	o_mantissa = a_mantissa + b_mantissa;
        	//Signify to shift
        	o_mantissa[24] = 1;
        	o_sign = a_sign;
      	end else begin // Opposite signs = subtract
        	if(a_mantissa > b_mantissa) begin
          	o_mantissa = a_mantissa - b_mantissa;
          	o_sign = a_sign;
        	end else begin
       		  o_mantissa = b_mantissa - a_mantissa;
     		    o_sign = b_sign;
        	end
      	end
    end else begin //Unequal exponents
      	if (a_exponent > b_exponent) begin // A is bigger
        	o_exponent = a_exponent;
        	o_sign = a_sign;
			    diff = a_exponent - b_exponent;
        	tmp_mantissa = b_mantissa >> diff;
        	if (a_sign == b_sign)
          		o_mantissa = a_mantissa + tmp_mantissa;
        	else
          		o_mantissa = a_mantissa - tmp_mantissa;
     		end else if (a_exponent < b_exponent) begin // B is bigger
     		  o_exponent = b_exponent;
     		  o_sign = b_sign;
       		diff = b_exponent - a_exponent;
       		tmp_mantissa = a_mantissa >> diff;
        	if (a_sign == b_sign)
          		o_mantissa = b_mantissa + tmp_mantissa;
     		  else
				      o_mantissa = b_mantissa - tmp_mantissa;
      	end
    end

    if(o_mantissa[24] == 1) begin
      	o_exponent = o_exponent + 1;
      	o_mantissa = o_mantissa >> 1;
    end else if((o_mantissa[23] != 1) && (o_exponent != 0)) begin
      	i_e = o_exponent;
      	i_m = o_mantissa;
      	o_exponent = o_e;
      	o_mantissa = o_m;
    end
  end
endmodule 

module addition_normaliser(in_e, in_m, out_e, out_m);
  input [7:0] in_e;
  input [24:0] in_m;
  output [7:0] out_e;
  output [24:0] out_m;
  
  wire [7:0] in_e;
  wire [24:0] in_m;
  reg [7:0] out_e;
  reg [24:0] out_m;
  
  
  always @ ( * ) begin
    if (in_m[23:3] == 21'b000000000000000000001) begin
	  out_e = in_e - 20;
	  out_m = in_m << 20;
	end else if (in_m[23:4] == 20'b00000000000000000001) begin
	  out_e = in_e - 19;
	  out_m = in_m << 19;
	end else if (in_m[23:5] == 19'b0000000000000000001) begin
	  out_e = in_e - 18;
	  out_m = in_m << 18;
	end else if (in_m[23:6] == 18'b000000000000000001) begin
	  out_e = in_e - 17;
	  out_m = in_m << 17;
	end else if (in_m[23:7] == 17'b00000000000000001) begin
	  out_e = in_e - 16;
	  out_m = in_m << 16;
	end else if (in_m[23:8] == 16'b0000000000000001) begin
	  out_e = in_e - 15;
	  out_m = in_m << 15;
	end else if (in_m[23:9] == 15'b000000000000001) begin
	  out_e = in_e - 14;
	  out_m = in_m << 14;
	end else if (in_m[23:10] == 14'b00000000000001) begin
	  out_e = in_e - 13;
	  out_m = in_m << 13;
	end else if (in_m[23:11] == 13'b0000000000001) begin
	  out_e = in_e - 12;
	  out_m = in_m << 12;
	end else if (in_m[23:12] == 12'b000000000001) begin
	  out_e = in_e - 11;
	  out_m = in_m << 11;
	end else if (in_m[23:13] == 11'b00000000001) begin
	  out_e = in_e - 10;
      out_m = in_m << 10;
	end else if (in_m[23:14] == 10'b0000000001) begin
	  out_e = in_e - 9;
	  out_m = in_m << 9;
	end else if (in_m[23:15] == 9'b000000001) begin
	  out_e = in_e - 8;
	  out_m = in_m << 8;
	end else if (in_m[23:16] == 8'b00000001) begin
	  out_e = in_e - 7;
	  out_m = in_m << 7;
	end else if (in_m[23:17] == 7'b0000001) begin
	  out_e = in_e - 6;
      out_m = in_m << 6;
	end else if (in_m[23:18] == 6'b000001) begin
	  out_e = in_e - 5;
	  out_m = in_m << 5;
	end else if (in_m[23:19] == 5'b00001) begin
	  out_e = in_e - 4;
	  out_m = in_m << 4;
	end else if (in_m[23:20] == 4'b0001) begin
	  out_e = in_e - 3;
	  out_m = in_m << 3;
	end else if (in_m[23:21] == 3'b001) begin
	  out_e = in_e - 2;
	  out_m = in_m << 2;
	end else if (in_m[23:22] == 2'b01) begin
	  out_e = in_e - 1;
	  out_m = in_m << 1;
	end
  end
endmodule

module PE #(
	parameter ADD_BW = 32, // note parameters are kinda set for this desgin due to fixed multipler & adder units
	parameter MUL_BW = 16) (
	input clk,
	input rst,
	input i_mode,
	input [ADD_BW-1:0] i_top,
	input [MUL_BW-1:0] i_left,
	output reg [ADD_BW-1:0] o_bot,
	output reg [MUL_BW-1:0] o_right);

	reg [MUL_BW-1:0] r_buffer; // weight register
	wire [MUL_BW-1:0] w_mult_out;
	
	wire [ADD_BW-1:0] w_adder_in;
	wire [ADD_BW-1:0] w_adder_out;
	
	wire [ADD_BW-1:0] w_out;
	
	// set weight buffer when i_mode = 0 (load)
	always @ (*) begin
		if (rst == 1'b1) begin
			r_buffer = 'd0;
		end else begin
			if (i_mode == 1'b0) begin
				r_buffer = i_top[MUL_BW-1:0];
			end
		end
	end
	
	// set adder in when i_mode = 1 (accum), else set to zero
	assign w_adder_in = i_mode ? i_top : 'd0;
	
	
	bfp16_mult mult1(
		.clk(clk),
		.rst(rst),
		.A(i_left),
		.B(r_buffer),
		.O(w_mult_out)
	);
	
	bfp32_adder adder1(
		.clk(clk),
		.rst(rst),
		.A(w_adder_in),
		.B({w_mult_out, 16'b0}),
		.O(w_adder_out)
	);
	
	// assign output wire to either w_adder_out or 16:0 for loading data
	assign w_out = i_mode ? w_adder_out: {16'b0, i_top[MUL_BW-1:0]};
	
	// flop outputs
	always @ (posedge clk) begin
        o_bot <= w_out;
        o_right <= i_left;
	end

    always @ (posedge rst) begin
        o_bot <= 'd0;
        o_right <= 'd0;
	end
endmodule

module MAC #(
    parameter ARR_SIZE = 4, // set to 128 during final synthesis 
    parameter VERTICAL_BW = 32,
    parameter HORIZONTAL_BW = 16,
    parameter ACC_SIZE = 64 ) (
    input clk,
    input i_mode,
    input rst,
    input [HORIZONTAL_BW * ARR_SIZE - 1 : 0] vertical_input,
    input [HORIZONTAL_BW * ARR_SIZE - 1 : 0] horizontal_input,
    output reg [ARR_SIZE * VERTICAL_BW - 1 : 0] MAC_OP );

    wire [HORIZONTAL_BW-1:0]horizontal_wires[ARR_SIZE-1:0][ARR_SIZE-1:0];
    wire [VERTICAL_BW-1:0]vertical_wires[ARR_SIZE-1:0][ARR_SIZE-1:0];

    generate
        
        for (genvar i=0; i<ARR_SIZE; i=i+1) begin // generates rows of elements
            for (genvar j=0; j<ARR_SIZE; j=j+1) begin // generate each row of elements
                
                // Types of elements
                //  1) Corner Elements:
                //      1) Top-left corner
                //      2) Top-right corner - handled in top row scenario
                //      3) Bottom-left corner - handled in bottom row scenario
                //      4) Bottom right corner - handled in bottom row scenario
                //  2) Edge elements
                //      1) 1st row of elements
                //      2) 1st column of elements
                //      3) last row of elements - handled by other elements
                //      4) last column of elements  - handled by other elements
                //  3) other elements
                // total of 4 different types of elements to be coded


                if(i==0 && j==0) begin //top-left corner element
                    PE pe_instance(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top({16'b0,vertical_input[ (j+1) * HORIZONTAL_BW - 1 : j * HORIZONTAL_BW]}),
                        .i_left(horizontal_input[ (i+1) * HORIZONTAL_BW - 1 : i * HORIZONTAL_BW]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );

                end

                if(i==0 && j!=0) begin //Top elements
                    PE pe_instance(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top({16'b0,vertical_input[(j+1) * HORIZONTAL_BW - 1 : j * HORIZONTAL_BW]}),
                        .i_left(horizontal_wires[i][j-1]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

                if(i!=0 && j==0) begin //Left elements
                    PE pe_instance(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top(vertical_wires[i-1][j]),
                        .i_left(horizontal_input[(i+1) * HORIZONTAL_BW - 1 : i * HORIZONTAL_BW]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

                if(i!=0 && j!=0) begin //Other elements
                    PE pe_instance(
                        .clk(clk),
                        .rst(rst),
                        .i_mode(i_mode),
                        .i_top(vertical_wires[i-1][j]),
                        .i_left(horizontal_wires[i][j-1]),
                        .o_bot(vertical_wires[i][j]),
                        .o_right(horizontal_wires[i][j])
                    );
                end

            end

        end

        for(genvar k=0; k<ARR_SIZE; k=k+1) begin
            assign MAC_OP[(k+1) * VERTICAL_BW - 1 : k * VERTICAL_BW] = vertical_wires[ARR_SIZE-1][k];
        end
    endgenerate
endmodule

module individual_buffer #(
    parameter ARR_SIZE = 4  )(
    input clk,
    input rst,
    input [15:0] individual_input,    //64-bit input from the external interface
    input [1:0] state,
    output reg [15:0] individual_output ); //64-bit output to the controller
    
    parameter QUEUE_DEPTH = ARR_SIZE*2; //Maximum number of instructions in the queue
    parameter ADDR_WIDTH = $clog2(QUEUE_DEPTH);   //Number of bits needed to address memory locations - log2(QUEUE_DEPTH)

    // FIFO queue
    reg [15:0] queue [QUEUE_DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] head, tail;
    reg [ADDR_WIDTH:0] count; //Number of instructions in the queue

    //Initialisation
    initial begin
        head = 0;
        tail = 0;
        count = 0;
        individual_output = 16'b0;
    end
    
    always @(posedge clk) begin

        // Enqueue - Load instruction from interface to the queue
        if (state == 2'b01) begin
            queue[tail] <= individual_input;  // Load instruction to the queue
            tail <= (tail + 1) % QUEUE_DEPTH; // Increment tail pointer (go back to 0 when its the end, stay in the range 0 to QUEUE_DEPTH-1)
            count <= count + 1;             // Increment instruction count
        end
        
        else if (state == 2'b10) begin // Dequeue - Send instruction to the controller
            individual_output <= queue[head]; // Send instruction to controller
            head <= (head + 1) % QUEUE_DEPTH;   // Increment head pointer (refer comment for tail)
            count <= count - 1;               // Decrement instruction count
        end
        else if (state == 2'b00) begin
            // No operation: Hold state
            individual_output <= 16'b0;
        end
    end

    always @(posedge rst) begin
        
        head = 0;
        tail = 0;
        queue[0] = 16'b0;
    end
endmodule

module BankedBuffer #(
    parameter ARR_SIZE = 4 ) (
    input wire clk,            // Clock signal
    input wire rst,            // Reset signal
    input wire [31:0] data_in, // 32-bit input data
    input wire [6:0] addr,     // 7-bit address for 2^14 elements
    input wire [1:0] state,    // Two-bit state: 00 = No operation, 01 = Store, 10 = Stream
    output reg [ARR_SIZE*16-1:0] data_out ); // 64-bit output data (4 concatenated 32-bit elements)
    // Structural logic
    wire[ARR_SIZE*16-1:0] op_wire;

    genvar i;
    generate
        for (i = 0; i < ARR_SIZE; i = i + 1) begin : module_instances
                individual_buffer inst (
                    .clk(clk),
                    .rst(rst),
                    .individual_input((addr == i) ? data_in[15:0] : ((addr == i-1 ) ? data_in[31:16]:16'b0)), // Input goes to the selected instance
                    .state((state != 2'b01) ? ((addr == i) ? state : 2'b00) : state),
                    .individual_output(op_wire[(i+1)*16-1:i*16])
                );
            end
    endgenerate

    // Procedural at clock edge
    always @(posedge clk) begin
        data_out <= op_wire;
    end
endmodule

module Accumulator #(
    parameter ARR_SIZE = 4,
    parameter VERTICAL_BW = 32 )(
    input clk,
    input rst,
    input [3:0] op_buffer_address,
    input [ARR_SIZE * VERTICAL_BW - 1:0] accumulated_val,
    input acc_reset,
    input store_output,
    output reg [31:0] output_data,
    output reg [3:0] output_buffer_addr,
    output reg output_buffer_enable );

    reg [31:0] accumulator_op = 32'b0;
    wire [31:0] accumulator_op_intermediate_wire[ARR_SIZE - 1:0];

    generate
        for (genvar k = 0; k < ARR_SIZE; k = k + 1) begin : gen_final_accumulation

            if (k==0) begin // Left-most element
                bfp32_adder accumulator_intermediate( 
                    .clk(clk),
                    .rst(acc_reset || rst),
                    .A(accumulated_val[(k+1) * VERTICAL_BW - 1 : k * VERTICAL_BW]),
                    .B(accumulated_val[(k+2) * VERTICAL_BW - 1 : (k+1) * VERTICAL_BW]),
                    .O(accumulator_op_intermediate_wire[k]) 
                );
            end

            else if(k==ARR_SIZE-1) begin // Right-most element
                bfp32_adder accumulator_intermediate( 
                    .clk(clk),
                    .rst(acc_reset || rst),
                    .A(accumulator_op_intermediate_wire[k-1]),
                    .B(accumulator_op),
                    .O(accumulator_op_intermediate_wire[k]) 
                );
            end

            else begin // intermediate elements
                bfp32_adder accumulator_intermediate( 
                    .clk(clk),
                    .rst(acc_reset || rst),
                    .A(accumulator_op_intermediate_wire[k-1]),
                    .B(accumulated_val[(k+2) * VERTICAL_BW - 1 : (k+1) * VERTICAL_BW]),
                    .O(accumulator_op_intermediate_wire[k]) 
                );
            end
        end
    endgenerate

    // Procedural logic with reset
    always @(posedge clk) begin
        output_data = 32'b0;

        // Update outputs
        if (store_output == 1'b1) begin
            output_data <= accumulator_op;
            output_buffer_addr <= op_buffer_address;
            output_buffer_enable <= store_output;

            // Update procedural registers with structural results
            accumulator_op <= accumulator_op_intermediate_wire[ARR_SIZE-1];
        end
    end

    // Procedural logic with reset
    always @(posedge rst) begin
        output_data = 32'b0;
        accumulator_op <= 32'b0;
    end
endmodule

module controller #(
    )(
    input clk,
    input [63:0] instruction,
    output reg [6:0] inp_buf_addr,
    output reg [31:0] inp_buf_data,
    output reg [6:0] wt_buf_addr,
    output reg [31:0] wt_buf_data,
    output reg [3:0] acc_to_op_buf_addr,
    output reg acc_result_to_op_buf,
    output reg [3:0] out_buf_addr,
    output reg op_buffer_instr_for_sending_data,
    output reg instr_for_accum_to_reset,
    output reg [1:0] state_signal, //01 for write enable, 10 to start streaming data, 00 NOP
    output reg i_mode );

    // Internal registers
    reg [4:0] opcode;
    reg [13:0] address;
    reg [31:0] data;

    //Instruction Decode    
    always @(posedge clk) begin
        opcode = instruction[4:0]; // 5-bit opcode
        address = instruction[20:5]; // 16-bit address
        data = instruction[52:21]; // 32-bit data

        //Initialisation
        inp_buf_addr = 7'b0;
        inp_buf_data = 32'b0;
        wt_buf_addr = 7'b0;
        wt_buf_data = 32'b0;
        acc_to_op_buf_addr = 4'b0;
        acc_result_to_op_buf = 1'b0;
        out_buf_addr = 4'b0;
        op_buffer_instr_for_sending_data = 1'b0;
        instr_for_accum_to_reset = 1'b0;
        state_signal = 2'b0;
        i_mode = 1'b0;

        // Opcode based decode
        case (opcode)
            5'b00000: begin 
                //No instruction received
            end
            5'b11111: begin 
                //NOP
            end   
            5'b00001: begin // MAC
                state_signal <= 2'b10; //Command to start streaming the inputs
            end
            5'b00010: begin // Send weights
                state_signal <= 2'b10; //Command to start streaming the weights
                i_mode <= 1'b1; //Signal to MAC to start accepting weights from the weight buffer
            end
            5'b00011: begin // Store Output
                state_signal <= 2'b01; //Write enble
                acc_to_op_buf_addr <= address[3:0]; // Destination in output buffer
                acc_result_to_op_buf <= 1'b1; // Send accumulator result
            end
            5'b00100: begin // Receive inputs
                state_signal <= 2'b01; //Write enble
                inp_buf_addr <= address[6:0]; // Destination address in input buffer
                inp_buf_data <= data; // Data to be stored in input buffer
            end
            5'b00101: begin // Receive weights
                state_signal <= 2'b01; //Write enble
                wt_buf_addr <= address[6:0]; // Destination address in weight buffer
                wt_buf_data <= data; // Data to be stored in weight buffer
            end
            5'b00110: begin // Transmit output
                out_buf_addr <= address[3:0]; // Source address in output buffer
                op_buffer_instr_for_sending_data <= 1'b1;
            end
            5'b00111: begin // Reset accumulator
                instr_for_accum_to_reset <= 1'b1; 
            end       
            default: begin
                //Unknown Opcode,do nothing
            end
        endcase
    end
endmodule

module instruction_buffer (
    input clk,
    input rst,
    input external_clk, //External interface clock assuming both are different
    input [63:0] interface_input,    //64-bit input from the external interface
    output reg [63:0] instr_to_controller, //64-bit output to the controller
    output reg buffer_full                  //Signal indicating the buffer is buffer_full
    );

    // Parameters for the queue
    parameter QUEUE_DEPTH = 64; //Maximum number of instructions in the queue
    parameter ADDR_WIDTH = 6;   //Number of bits needed to address memory locations - log2(QUEUE_DEPTH)

    // FIFO queue
    reg [63:0] queue [QUEUE_DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] head, tail;
    reg [ADDR_WIDTH:0] count; //Number of instructions in the queue

    //Initialisation
    initial begin
        head = 0;
        tail = 0;
        count = 0;
        buffer_full = 0;
        instr_to_controller = 64'b0;
    end

    always @(posedge external_clk) begin
        // Check if the buffer is full
        buffer_full <= (count == QUEUE_DEPTH);

        // Enqueue - Load instruction from interface to the queue
        if (!buffer_full) begin
            queue[tail] <= interface_input;  // Load instruction to the queue
            tail <= (tail + 1) % QUEUE_DEPTH; // Increment tail pointer (go back to 0 when its the end, stay in the range 0 to QUEUE_DEPTH-1)
            count <= count + 1;             // Increment instruction count
        end
    end
    
    always @(posedge clk) begin
        
        if (count > 0) begin // Dequeue - Send instruction to the controller
            instr_to_controller <= queue[head]; // Send instruction to controller
            head <= (head + 1) % QUEUE_DEPTH;   // Increment head pointer (refer comment for tail)
            count <= count - 1;               // Decrement instruction count
        end   
    end

    always @(posedge rst) begin
        
        head = 0;
        tail = 0;
        queue[0] = 64'b0;
    end
endmodule

module Output_buffer #(
    )(
    input clk,
    input rst,
    input [31:0] data,
    input [3:0] op_buf_addr_for_store,
    input [3:0] op_buf_addr_for_external_comm,
    input op_buffer_instr_for_storing_data,
    input op_buffer_instr_for_sending_data,
    output reg [31:0] res_to_external
    );

    reg [31:0] buf_data [0:15];

    always @(posedge clk) begin
        
        if(op_buffer_instr_for_sending_data==1'b1) begin
            res_to_external <= buf_data[op_buf_addr_for_external_comm];
        end
        if(op_buffer_instr_for_storing_data==1'b1) begin
            buf_data[op_buf_addr_for_store] <= data;
        end
    end
    always @(posedge clk) begin
        
        for(integer i=0;i<16;i=i+1) begin
            buf_data[i] <= 32'b0;
        end
    end
endmodule

module SystolicArray #(
    parameter ARR_SIZE = 4
    )(
    input clk,
    input rst,
    input external_clk,
    input [63:0] accelerator_input,
    output reg [31:0] accelerator_output,
    output reg buffer_full
    );

    wire [63:0] instr_buffer_to_controller;

    wire [6:0] controller_to_inp_buf_addr;
    wire [31:0] controller_to_inp_buf_data;
    wire [6:0] controller_to_wt_buf_addr;
    wire [31:0] controller_to_wt_buf_data;
    wire [3:0] controller_to_acc_op_addr;
    wire controller_to_acc_send_op;
    wire [3:0] controller_to_op_buf_addr;
    wire controller_to_op_buf_instr;
    wire instr_for_accum_to_reset;
    wire [1:0] state_signal;
    wire i_mode;
    wire buffer_full_wire;


    instruction_buffer instr_buffer_instance(
        .clk(clk),
        .rst(rst),
        .external_clk(external_clk),
        .interface_input(accelerator_input),
        .instr_to_controller(instr_buffer_to_controller),
        .buffer_full(buffer_full_wire)
    );

    controller controller_instance(
        .clk(clk),
        .instruction(instr_buffer_to_controller),
        .inp_buf_addr(controller_to_inp_buf_addr),
        .inp_buf_data(controller_to_inp_buf_data),
        .wt_buf_addr(controller_to_wt_buf_addr),
        .wt_buf_data(controller_to_wt_buf_data),
        .acc_to_op_buf_addr(controller_to_acc_op_addr),
        .acc_result_to_op_buf(controller_to_acc_send_op),
        .acc_to_op_buf_addr(controller_to_op_buf_addr),
        .op_buffer_instr_for_sending_data(controller_to_op_buf_instr),
        .instr_for_accum_to_reset(instr_for_accum_to_reset),
        .state_signal(state_signal),
        .i_mode(i_mode)
    );

    wire [32*ARR_SIZE-1:0] mac_to_accumulator;
    wire [16*ARR_SIZE-1:0] mac_vertical_input;
    wire [16*ARR_SIZE-1:0] mac_horizontal_input;

    MAC mac_instance(
        .clk(clk),
        .i_mode(i_mode),
        .rst(rst),
        .vertical_input(mac_vertical_input),
        .horizontal_input(mac_horizontal_input),
        .MAC_OP(mac_to_accumulator)
    );

    wire [31:0] acc_to_op_buf_data;
    wire [3:0] acc_to_op_buf_addr;
    wire acc_to_op_buf_enable;
    wire [31:0] op_buf_output;

    Output_buffer Output_buffer_instance(
        .clk(clk),
        .rst(rst),
        .data(acc_to_op_buf_data),
        .op_buf_addr_for_store(acc_to_op_buf_addr),
        .op_buf_addr_for_external_comm(controller_to_op_buf_addr),
        .op_buffer_instr_for_storing_data(acc_to_op_buf_enable),
        .op_buffer_instr_for_sending_data(controller_to_op_buf_instr),
        .res_to_external(accelerator_output)
    );


    Accumulator Accumulator_instance(
        .clk(clk),
        .rst(rst),
        .op_buffer_address(controller_to_acc_op_addr),
        .accumulated_val(mac_to_accumulator),
        .acc_reset(instr_for_accum_to_reset),
        .store_output(controller_to_acc_send_op),
        .output_data(acc_to_op_buf_data),
        .output_buffer_addr(acc_to_op_buf_addr),
        .output_buffer_enable(acc_to_op_buf_enable)
    );

    BankedBuffer weight_buffer_instance (
        .clk(clk),
        .rst(rst),
        .data_in(controller_to_wt_buf_data),
        .addr(controller_to_wt_buf_addr),
        .state(state_signal), // Control signal: 00, 01, or 10
        .data_out(mac_vertical_input)
    );

    BankedBuffer input_buffer_instance (
        .clk(clk),
        .rst(rst),
        .data_in(controller_to_inp_buf_data),
        .addr(controller_to_inp_buf_addr),
        .state(state_signal), // Control signal: 00, 01, or 10
        .data_out(mac_horizontal_input)
    );

    always @(posedge clk) begin
        // Sequential processing logic
        accelerator_output <= op_buf_output;
        buffer_full <= buffer_full_wire;
    end

    always @(posedge rst) begin
        accelerator_output <= 32'b0;
        buffer_full <= 1'b0;
    end
endmodule