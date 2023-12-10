module PC_LUT #(parameter D=12)(
  input       [ 2:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
	3'b000: target = 3;	  // go ahead 3 spaces
   3'b001: target = 4;   // go back 4 spaces
	3'b010: target = 8;   // go ahead 8 spaces
	3'b011: target = 16;   // go back 13 space
	3'b100: target = 5;	  // go to instruction 5
	3'b101: target = 5;	  // go to instruction 5
	4'b110: target = 12;	  // go to instruction 300
	5'b111: target = 68;	  // go to instruction 400
	default: target = 'b0;  // hold PC
  endcase

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
