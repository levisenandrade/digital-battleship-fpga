module main(Saida, R, G, B, Vsync, Hsync, Cord, CLK, RST, mod, Enable);
	input CLK, RST, mod, Enable;
	input [5:0]Cord;
	input	[1:0] Inp;
	output [3:0]Saida; // Valor no LED pra verificação
	output [3:0] R;
	output [3:0] G;
	output [3:0] B;
	output Vsync, Hsync;
	
	// Divisor de frequência improvisado
	
	wire halfClock, d;
	
	FlipFlopD FF0(
    .clk(CLK),
    .rst(rst),
    .d(d),
    .q(halfClock));
	 
	 not(d, halfClock);
	
	
	// Adicionando a entrada na memória
	// Tipo de cor travado em Branco, com barco a escolha por meio das chaves
	
	Memoria Mem(
	.S(Saida), // Cor[1], Cor[0], Tipo[1], Tipo[0]
	.clk(CLK),
	.rst(RST),
	.inf({1'b1, 1'b1, Inp[0], Inp[1]}),
	.modo(mod),
	.coord(Cord));
	
	
	VGA_interface 
	u1(
		//INPUT
		.clk_25mhz(halfClock), 
		.reset(RST), 
		.write_enable(Enable),
		.data({Saida[3], Saida[2]}),
		.address(Cord), // Linha[5:3], Coluna[2:0]
	
		//OUTPUT
		.v_sync(Vsync), 
		.h_sync(Hsync),
		.R(R),
		.G(G),
		.B(B)
	);
	

endmodule