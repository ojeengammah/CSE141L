module Imm_LUT (
  input       [2:0] index,	   // target 4 values
  output logic[7:0] value);

  always_comb case(index)
   0: value = 0;   
	1: value = 1;   
	2: value = 20;	
	default: value = 0;  // hold PC  
  endcase

endmodule