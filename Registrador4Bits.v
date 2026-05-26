module Registrador4Bits(Q, Inp, rst, clk, modo);
	input clk, rst, modo;
	input [3:0] Inp;
	output [3:0] Q;
	
	wire [3:0] qff;


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
	 
	 // CONTROLE DE LEITURA/ESCRITA DOS FFS

	 
	 mux4Inp1Bit Mx0(
	 .S(qff),
	 .A(Q),
	 .B(Inp),
	 .slc(modo));
	 
	 
endmodule