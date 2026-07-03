module CodMefSigToSlc(
	input A, B, C, D,
	output [1:0]Slc
);

	assign Slc[1] = ~C & ~D;
	assign Slc[0] = ~B & ~D;

endmodule