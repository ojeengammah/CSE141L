module register_c_mux (
    input wire [1:0]select,       // Selection control
    input wire [2:0] choice0,  // Input data 0
    input wire [2:0] choice1,  // Input data 1
    input wire [2:0] choice2,  // Input data 2
    input wire [2:0] choice3,  // Input data 3
    output logic [2:0] regNum // Output data
);

always_comb begin
    case (select)
        2'b00: regNum = choice0;
        2'b01: regNum = choice1;
        2'b10: regNum = choice2;
        2'b11: regNum = choice3;
    endcase
end

endmodule
