module Registrador6Bits(Q, Inp, rst, clk, modo);
	input clk, rst, modo;
	input [5:0] Inp;
	output [5:0] Q;
	
	wire [5:0] qff;


	FlipFlopD FF0(
    .clk(clk),
    .rst(rst),
    .d(qff[0]),
    .q(Q[0]));
	 
	 FlipFlopD FF1(
    .clk(clk),
    .rst(rst),
    .d(qff[1]),
    .q(Q[1]));
	 
	 FlipFlopD FF2(
    .clk(clk),
    .rst(rst),
    .d(qff[2]),
    .q(Q[2]));
	 
	 FlipFlopD FF3(
    .clk(clk),
    .rst(rst),
    .d(qff[3]),
    .q(Q[3]));
	 
	 FlipFlopD FF4(
    .clk(clk),
    .rst(rst),
    .d(qff[4]),
    .q(Q[4]));
	 
	 FlipFlopD FF5(
    .clk(clk),
    .rst(rst),
    .d(qff[5]),
    .q(Q[5]));
	 
	 // CONTROLE DE LEITURA/ESCRITA DOS FFS

	 
	 mux4Inp1Bit Mx0(
	 .S(qff[0:3]),
	 .A(Q[0:3]),
	 .B(Inp),
	 .slc(modo));
	 
	mux1bit Mx1(
	.A(qff[4]),
	.B(Q[4]),
	.slc(Inp),
	.S(modo));
	
	mux1bit Mx2(
	.A(qff[5]),
	.B(Q[5]),
	.slc(Inp),
	.S(modo));
	
	
endmodule