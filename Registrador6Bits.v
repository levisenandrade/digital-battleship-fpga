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
	 .S({qff[3], qff[2], qff[1], qff[0]}),
	 .A({Q[3], Q[2], Q[1], Q[0]}),
	 .B(Inp),
	 .slc(modo));
	 
	mux1bit Mx1(
	.A(Q[4]),
	.B(Inp),
	.slc(modo),
	.S(qff[4]));
	
	mux1bit Mx2(
	.A(Q[5]),
	.B(Inp),
	.slc(modo),
	.S(qff[5]));
	
	
endmodule