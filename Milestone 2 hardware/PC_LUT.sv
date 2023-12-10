module PC_LUT #(parameter D=12)(
  input       [ 2:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
	3'b000: target = 5;	  // go ahead 5 spaces
   3'b001: target = -5;   // go back 5 spaces
	3'b010: target = 20;   // go ahead 20 spaces
	3'b011: target = -1;   // go back 1 space   
	3'b100: target = 100;	  // go to instruction 100
	3'b101: target = 200;	  // go to instruction 200
	4'b110: target = 300;	  // go to instruction 300
	5'b111: target = 400;	  // go to instruction 400
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
