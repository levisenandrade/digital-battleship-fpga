module trocaCor(
	input [1:0] corInp,
	output [1:0] corOut
);

	assign corOut[1] = corInp[1] & ~corInp[0];
	assign corOut[0] = corInp[0];
	
endmodule