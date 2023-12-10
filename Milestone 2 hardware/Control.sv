// control decoder
module Control (
  input [4:0] opcode,
  input [2:0] funct1,
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
  
  
  if (opcode == 5'b00000) begin
    Reg_C = 2'b00;
	 Write_Reg = 1'b1;
	 if (funct2 == 1'b0)
	   ALU_Op = 2'b10;
    else
	   ALU_Op = 2'b01;
  end else if (opcode[4:3] == 2'b00) begin
    Reg_C = 2'b01;
	 Write_Reg = 1'b1;
	 ALU_Op = 2'b00;
	 if (funct1 == 3'b110)
	   Write_Reg = 1'b0;
  end else if (opcode[4:3] == 2'b01) begin
    Reg_C = 2'b10;
	 Write_Reg = !funct2;
	 Mem_Write = funct2;
	 Write_C = 2'b01;
  end else if (opcode[4:3] == 2'b10) begin
    Reg_C = 2'b11;
	 Branch = 1'b1;
	 Write_Reg = 1'b0;
	 ALU_Op = 2'b11;
  end else if (opcode[4:3] == 2'b11) begin
    Reg_C = 2'b10;
	 Write_Reg = 1'b1;
	 Write_C = {1'b1, funct2};
  end
/*case(instr)    // override defaults with exceptions
  'b0000:  begin					// store operation
               MemWrite = 'b1;      // write to data mem
               RegWrite = 'b0;      // typically don't also load reg_file
			  end
  'b00001:  ALUOp      = 'b000;  // add:  y = a+b
  'b00010:  begin				  // load
			   MemtoReg = 'b1;    // 
            end
// ...
endcase*/

end
	
endmodule