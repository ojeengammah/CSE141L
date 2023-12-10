`timescale 1ns / 1ps

module alu_tb;

  // Inputs
  reg [2:0] alu_cmd;
  reg [1:0] ALU_Op;
  reg [7:0] inA, inB;

  // Outputs
  wire [7:0] rslt;
  wire zero;

  // Instantiate the ALU module
  alu my_alu (
    .alu_cmd(alu_cmd),
    .ALU_Op(ALU_Op),
    .inA(inA),
    .inB(inB),
    .rslt(rslt),
    .zero(zero)
  );


  // Test case setup
  initial begin
    // Test case 1: ALU operation 001 (left_shift)
    alu_cmd = 3'b001;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A << 03");
	 $display("Expected: %b", 8'b11010000);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);

    // Test case 2: ALU operation 010 (right_shift)
    alu_cmd = 3'b010;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A >> 03");
	 $display("Expected: %b", 8'b00000111);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);

    //Test Case 3: ALU operation 011 (bitwise_and)
    alu_cmd = 3'b011;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A & 03");
	 $display("Expected: %b", 8'b00000010);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);

    //Test Case 4: ALU operation 100 (bitwise_or)
    alu_cmd = 3'b100;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A | 03");
	 $display("Expected: %b", 8'b00111011);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);

    //Test Case 5: ALU operation 101 (bitwise_xor)
    alu_cmd = 3'b101;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A ^ 03");
	 $display("Expected: %b", 8'b00111001);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);

    //Test Case 6: ALU operation 110 (no op )
    alu_cmd = 3'b110;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: No Op");
	 $display("Expected: %b", 8'b00000000);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);

    //Test Case 7: ALU operation 111 (parity)
    alu_cmd = 3'b111;
    ALU_Op = 2'b00;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: ^(03)");
	 $display("Expected: %b", 8'b00000000);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);
	 
    inA = 8'h3A; //00111010
    inB = 8'h07; //00000111
    #10;
	 $display("ALU Instruction: ^(04)");
	 $display("Expected: %b", 8'b00000001);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);
	 
    //Test Case 8: ALU operation 01 (dec)
    ALU_Op = 2'b01;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A--");
	 $display("Expected: %b", 8'b00111001);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);
	 
    //Test Case 9: ALU operation 10 (inc)
    ALU_Op = 2'b10;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A++");
	 $display("Expected: %b", 8'b00111011);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);
	 
    //Test Case 10: ALU operation 11 (sub)
    ALU_Op = 2'b11;
    inA = 8'h3A; //00111010
    inB = 8'h03; //00000011
    #10;
	 $display("ALU Instruction: 3A - 03");
	 $display("Expected: %b", 8'b00110111);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);	 
	 
	 inA = 8'h3A; //00111010
    inB = 8'h3A; //00111010
    #10;
	 $display("ALU Instruction: 3A - 3A");
	 $display("Expected: %b", 8'b00000000);
    $display("Result: %b", rslt);
    $display("Zero: %b", zero);
  end


endmodule

