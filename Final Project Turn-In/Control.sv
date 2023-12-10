// control decoder
module Control (
  input [4:0] opcode,
  input funct1,
  input funct2,// subset of machine code (any width you need)
  output logic Branch, Write_Reg, Mem_Write, 
  output logic[1:0] ALU_Op,
  output logic[1:0] Reg_C, Write_C);	   // for up to 8 ALU operations

always_comb begin
// defaults
  Branch 	=  'b0;   // 1: branch (jump)
  Write_Reg =	'b0;   // 
  Mem_Write =	'b0;   // 
  Reg_C 	   =  2'b00;   // 
  Write_C   =	2'b00;   // 
  ALU_Op	   =  2'b00; // 
  
  
  if (opcode == 5'b00000) begin	// a type
    Reg_C = 2'b00;
	 Write_Reg = 1'b1;
	 if (funct1 == 1'b0)
	   ALU_Op = 2'b10;
    else
	   ALU_Op = 2'b01;
  end else if (opcode[4:3] == 2'b00) begin	// r type
    Reg_C = 2'b01;
	 Write_Reg = 1'b1;
	 ALU_Op = 2'b00;
	 if (opcode[2:0] == 3'b110)
	   Write_Reg = 1'b0;
  end else if (opcode[4:3] == 2'b01) begin	// load / store
    Reg_C = 2'b10;
	 Write_Reg = !funct2;
	 Mem_Write = funct2;
	 Write_C = 2'b01;
  end else if (opcode[4:3] == 2'b10) begin	// branch
    Reg_C = 2'b01;
	 Branch = 1'b1;
	 Write_Reg = 1'b0;
	 ALU_Op = 2'b11;
  end else if (opcode[4:3] == 2'b11) begin
    Reg_C = {1'b1, !funct2};
	 Write_Reg = 1'b1;
	 Write_C = {1'b1, funct2};
  end

end
	
endmodule