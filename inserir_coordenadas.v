// ??? Isso dá pra instanciar na main diretamente no começo

module inserir_coordenadas(
	input [2:0] linha,
	input [2:0] coluna,
	
	output [5:0] endereco
);

	assign endereco = {linha, coluna};
endmodule
