module write_c_mux (
    input wire [1:0]select,       // Selection control
    input wire [7:0] choice0,  // Input data 0
    input wire [7:0] choice1,  // Input data 1
    input wire [7:0] choice2,  // Input data 2
    input wire [7:0] choice3,  // Input data 3
    output logic [7:0] datOut // Output data
);

always_comb begin
    case (select)
        2'b00: datOut = choice0;
        2'b01: datOut = choice1;
        2'b10: datOut = choice2;
        2'b11: datOut = choice3;
    endcase
end

endmodule
