module select_adder (
	input logic [15:0] A, B,
	input logic  cin,
	output logic [15:0] S,
	output logic   cout
);

	logic c1, c2, c3;
	
	select_adder_CRA CRA0(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout(c1));
	select_adder_CRA CRA1(.A(A[7:4]), .B(B[7:4]), .cin(c1), .S(S[7:4]), .cout(c2));
   select_adder_CRA CRA2(.A(A[11:8]), .B(B[11:8]), .cin(c2), .S(S[11:8]), .cout(c3));
	select_adder_CRA CRA3(.A(A[15:12]), .B(B[15:12]), .cin(c3), .S(S[15:12]), .cout(cout));

endmodule

module select_adder_CRA (
	input logic [3:0] A, B,
	input logic cin,
	output logic [3:0] S,
	output logic cout
);

	logic c01, c02, c03, c04, c11, c12, c13, c14;
	logic [3:0] S0, S1;
	
	//carry of 0
	
	full_adder FA00(.x(A[0]), .y(B[0]), .z(1'b0), .s(S0[0]), .c(c01));
	full_adder FA01(.x(A[1]), .y(B[1]), .z(c01), .s(S0[1]), .c(c02));
	full_adder FA02(.x(A[2]), .y(B[2]), .z(c02), .s(S0[2]), .c(c03));
	full_adder FA03(.x(A[3]), .y(B[3]), .z(c03), .s(S0[3]), .c(c04));
	
	//carry of 1
	
	full_adder FA10(.x(A[0]), .y(B[0]), .z(1'b1), .s(S1[0]), .c(c11));
	full_adder FA11(.x(A[1]), .y(B[1]), .z(c11), .s(S1[1]), .c(c12));
	full_adder FA12(.x(A[2]), .y(B[2]), .z(c12), .s(S1[2]), .c(c13));
	full_adder FA13(.x(A[3]), .y(B[3]), .z(c13), .s(S1[3]), .c(c14));
	
	always_comb
		begin
		cout = cin ? c14 : c04;
	
		S = cin ? S1 : S0;

		end
endmodule
	