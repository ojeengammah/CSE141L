module Imm_LUT (
  input       [4:0] index,	   // target 4 values
  output logic[7:0] value);

  always_comb begin
    case(index)
      0: value = 0;
    	1: value = 1;
    	2: value = 2;
      3: value = 3;
		4: value = 4;
		5: value = 5;
		6: value = 6;
		7: value = 14;
		8: value = 16;
		9: value = 30;
		10: value = 31;
		11: value = 32;
		12: value = 33;
		13: value = 60;
		14: value = 91;
		15: value = 109;
		16: value = 142;
		17: value = 170;
		18: value = 204;
		19: value = 224;
		20: value = 225;
		21: value = 240;
		22: value = 247;
		23: value = 254;
	   24: value = 85;
     25: value = 171;
     26: value = 90;
	default: value = 0;  // hold PC
   endcase
  end

endmodule
