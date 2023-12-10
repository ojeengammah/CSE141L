// sample top level design
module top_level(
  input        clk, reset,
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  	  // ALU command bit width

  wire[D-1:0] target, 			  // jump
              prog_ctr;

  wire[2:0] jumpAddr;

  wire[7:0]   datA,datB,		  // from RegFile
				  rslt;               // alu output

  wire[1:0] alu_op;

  logic branchEnQ;
  logic zeroQ;

  wire branch_en;

  wire  relj, absj;                     // from control to PC; relative jump enable
  wire  zero,
		  Branch,
		  Write_Reg,
		  Mem_Write;

  wire[1:0] Reg_C, Write_C;

  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_addrB;    // address pointers to reg_file
  wire[7:0] datWrite;
  wire[7:0] immediate;
  wire[7:0] memDatOut;

  assign branch_en = !zeroQ & branchEnQ;

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
          .clk              ,
		    .branch_en (branch_en),
		    .reljump_en (relj),
		    .absjump_en (absj),
		    .target           ,
		    .prog_ctr          );



// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// lookup table to facilitate jumps/branches
  assign jumpAddr = mach_code[6:4];

  PC_LUT #(.D(D))
    pl1 (.addr  (jumpAddr),
         .target (target));


// control decoder
  Control ctl1(.opcode(mach_code[8:4]),
  .funct1(mach_code[3]),
  .funct2(mach_code[6]),
  .Branch  ,
  .Write_Reg ,
  .Mem_Write   ,
  .Reg_C ,
  .Write_C   ,
  .ALU_Op (alu_op));

  //TODO: Use control output to choose rd_addrA and rd_addrB

  assign alu_cmd  = mach_code[6:4];
  assign relj = !mach_code[6];
  assign absj = mach_code[6];

  register_c_mux read1(.select(Reg_C),
	.choice0 (mach_code[2:0]),
	.choice1 ({1'b0, mach_code[3:2]}),
	.choice2 (mach_code[5:3]),
	.choice3 (3'b011),
	.regNum(rd_addrA));

  register_c_mux read2(.select(Reg_C),
	.choice0 (mach_code[2:0]),
	.choice1 ({1'b0, mach_code[1:0]}),
	.choice2 (mach_code[2:0]),
	.choice3 (3'b011),
	.regNum(rd_addrB));

  //TODO: choose data to write in
  write_c_mux write1(.select(Write_C),
	.choice0 (rslt),
	.choice1 (memDatOut),
	.choice2 (immediate),
	.choice3 (datB),
	.datOut(datWrite));


  reg_file #(.pw(3)) rf1(.dat_in(datWrite),	   // loads, most ops
              .clk         ,
              .wr_en   (Write_Reg),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrA),      // in place operation
              .datA_out(datA),
              .datB_out(datB));


  alu alu1(.alu_cmd(alu_cmd),
		 .ALU_Op (alu_op),
       		 .inA    (datA),
		 .inB    (datB),
		 .rslt (rslt),
		 .zero(zero));

  dat_mem dm1(.dat_in(datA)  ,  // from reg_file
              .clk           ,
	      .wr_en  (Mem_Write), // stores
	      .addr   (datB),
              .dat_out(memDatOut));


  Imm_LUT imm1 (.index(mach_code[4:0]) ,
    .value(immediate));


// registered flags from ALU
  always_ff @(negedge clk) begin
   zeroQ <= zero;
	 branchEnQ <= Branch;
  end

  assign done = prog_ctr == 151;

endmodule
