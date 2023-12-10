module PC_tb;

  // Parameters
  parameter D = 12;

  // Inputs
  reg reset;
  reg clk;
  reg branch_en;
  reg reljump_en;
  reg absjump_en;
  reg [D-1:0] target;

  // Outputs
  wire [D-1:0] prog_ctr;

  // Instantiate the PC module
  PC #(D) pc_inst (
    .reset(reset),
    .clk(clk),
    .branch_en(branch_en),
    .reljump_en(reljump_en),
    .absjump_en(absjump_en),
    .target(target),
    .prog_ctr(prog_ctr)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  initial begin
    // Initialize inputs
    reset = 0;
    clk = 0;
    branch_en = 0;
    reljump_en = 0;
    absjump_en = 0;
    target = 0;

    // Reset
    reset = 1;
    #10 reset = 0;
    $display("Initial PC: %d", prog_ctr);

    $display("Performing Relative Jump, +4");
    // Test relative jump
    branch_en = 1;
    reljump_en = 1;
    target = 4;
    #10;
    assert(prog_ctr == 4) else $display("Relative Jump Failed!");
    $display("Current PC: %d", prog_ctr);

    $display("Performing Absolute Jump To 8");
    // Test absolute jump
    branch_en = 1;
    reljump_en = 0;
    absjump_en = 1;
    target = 8;
    #10;
    assert(prog_ctr == 8) else $display("Absolute Jump Failed!");
    $display("Current PC: %d", prog_ctr);

    $display("No Jump Performed");
    // Test increment
    branch_en = 0;
    reljump_en = 0;
    absjump_en = 0;
    #10;
    assert(prog_ctr == 9) else $display("Increment Failed!");
    $display("Current PC: %d", prog_ctr);
    #10;
    assert(prog_ctr == 10) else $display("Increment Failed!");
    $display("Current PC: %d", prog_ctr);
    #10;
    assert(prog_ctr == 11) else $display("Increment Failed!");
    $display("Current PC: %d", prog_ctr);
    $display("Program Finished");
    $stop();
  end

endmodule
