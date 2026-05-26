module Memoria(S, clk, rst, inf, modo, coord);

	input clk, rst, modo;
	input [5:0] coord;
	input [3:0] inf;
	output [3:0] S;
	
	// 1. CRIAMOS APENAS UMA MATRIZ
	// São 64 linhas com cada célula guardando 4 bits.
	wire [3:0] saidas_dos_regs [0:63]; 

	// 2. INSTANCIAMOS OS FLIP-FLOPS SEPARADOS
	genvar i;
	generate
		 for (i = 0; i < 64; i = i + 1) begin : banco
				
			// O Decodificador de Escrita:
			// Só vira 1 se o "modo" for 1 E a "coord" for igual a este 'i'
			wire modo_local = modo & (coord == i);

			Registrador4Bits reg_inst (
					.Q(saidas_dos_regs[i]), // A saída vai direto para a gaveta 'i' da matriz
					.Inp(inf),              // O dado entra para todos
					.rst(rst),
					.clk(clk),
					.modo(modo_local)       // Só o registrador escolhido recebe a ordem de gravar
			);
				
		 end
	endgenerate

	// 3. O MULTIPLEXADOR
	// Como os dados já estão arrumados nas 64 gavetas da matriz, 
	// pedir a gaveta [coord] automaticamente gera um Mux de 64 canais no hardware!
	assign S = saidas_dos_regs[coord];
		
endmodule