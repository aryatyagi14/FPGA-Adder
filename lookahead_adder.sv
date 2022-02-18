module lookahead_adder (
input  logic [15:0] A, B,
input  logic  cin,
output logic [15:0] S,
output logic cout
);

 //internal carry bits
 logic [3:0] IC;
 
 //propogation and generate
 logic PG, GG;
 logic [3:0] P;
 logic [3:0] G;
 
 //call carry lookahead unit
 carry_lookahead_unit CLU2 (.P(P), .G(G), .cin(cin), .icarry(IC), .Pg(PG), .Gg(GG));
 
 //call the 4 bit CLA (chnage the cin values NOT DONE)
 four_bit_CLA FB0 (.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .Pg(P[0]), .Gg(G[0]));
 four_bit_CLA FB1 (.A(A[7:4]), .B(B[7:4]), .cin(IC[0]), .S(S[7:4]), .Pg(P[1]), .Gg(G[1]));
 four_bit_CLA FB2 (.A(A[11:8]), .B(B[11:8]), .cin(IC[1]), .S(S[11:8]), .Pg(P[2]), .Gg(G[2]));
 four_bit_CLA FB3 (.A(A[15:12]), .B(B[15:12]), .cin(IC[2]), .S(S[15:12]), .Pg(P[3]), .Gg(G[3]));
 
 assign cout = IC[3];

endmodule



module full_adder_extended ( input logic x, y, cin,
output logic s, p, g );
	always_comb begin
	s = x ^ y ^ cin;
	p = x ^ y;
	g = x & y;
	end
	endmodule



module carry_lookahead_unit (input logic [3:0] P, G,
input logic cin,
output logic [3:0] icarry,
output logic Pg, Gg );

//easiest to create Pg and Gg first
	always_comb begin
	Pg = P[0] & P[1] & P[2] & P[3];
	Gg = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);
	end
//Now we just have to create the C output bits
	always_comb begin
	icarry[0] = (cin & P[0]) | G[0];
	icarry[1] = (cin & P[0] & P[1]) | (G[0] & P[1]) | G[1];
	icarry[2] = (cin & P[0] & P[1] & P[2]) | (G[0] & P[1]  & P[2]) | (G[1] & P[2]) | G[2];
	icarry[3] = (cin & P[0] & P[1] & P[2] & P[3]) | (G[0] & P[1]  & P[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[2] & P[3]) | G[3];
	end
	endmodule

module four_bit_CLA ( input logic [3:0] A, B,
input logic cin,
output logic [3:0] S,
output logic Pg, Gg );
//these are the internal carry bits
	logic [3:0] ic;
//create p and gs
	logic [3:0] p;
	logic [3:0] g;
//call carry lookahead
	carry_lookahead_unit CLU1( .P(p), .G(g), .cin(cin), .icarry(ic), .Pg(Pg), .Gg(Gg));
//call adders
	full_adder_extended FA0  (.x(A[0]), .y(B[0]), .cin(cin), .s(S[0]), .p(p[0]), .g(g[0]));
	full_adder_extended FA1  (.x(A[1]), .y(B[1]), .cin(ic[0]), .s(S[1]), .p(p[1]), .g(g[1]));
	full_adder_extended FA2  (.x(A[2]), .y(B[2]), .cin(ic[1]), .s(S[2]), .p(p[2]), .g(g[2]));
	full_adder_extended FA3  (.x(A[3]), .y(B[3]), .cin(ic[2]), .s(S[3]), .p(p[3]), .g(g[3]));
endmodule
