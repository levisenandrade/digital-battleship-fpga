module main(Saida, R, G, B, Vsync, Hsync, Cord, CLK, RST, Enable);
	input CLK, RST, Enable;
	input [5:0]Cord;
	output [3:0]Saida; // Valor no LED pra verificação
	output [3:0] R;
	output [3:0] G;
	output [3:0] B;
	output Vsync, Hsync;
	
	// Divisor de frequência improvisado
	
	wire halfClock, d;
	
	FlipFlopD FF0(
    .clk(CLK),
    .rst(RST),
    .d(d),
    .q(halfClock));
	 
	 not(d, halfClock);
	
	// MEMÓRIA GERAL
	
	Memoria Mem(
	.S(Saida), // Cor[1], Cor[0], Tipo[1], Tipo[0]
	.clk(CLK),
	.rst(RST),
	.inf(),
	.modo(),
	.coord(Coordenada));
	
	
	// MEF GERAL
	
	wire DoneP1, DoneP2;
	
	mef_principal MEFGERAL(
	.Clk(CLK),
	.rst(RST),
	
	// Esses sinais são os Dones das MEFS 1 e 2
	.concluido1(DoneP1),
	.concluido2(DoneP2),
	
	// Esses sinais serão baseados no processo de reset do sistema, ou seja, pintar tudo de azul!
	.rstFeito( ),
	.startReset( ),
	
	// Esses Sinais são os toggles de início das MEFS 1 e 2
	.TglP1(TgglP1),
	.TglP2(TgglP2));
	
	wire TgglP1, TgglP2;
	
	MEFPlayer1 instancia_mefp1 (
	
	.Toggle(TgglP1),
	// Dá o start da MEF
	
   .PshBttn(),
	 // PSHBTTN COM DETECTOR DE BORDA E DEBOUNCER
	 // A LÓGICA TÁ NORMAL, ATIVO -> 1
	 
   .MinAtingido(ContDone),
	// SINAL DE QUE OS 4 TIPOS DE BARCOS JÁ FORAM COLOCADOS.
	// MÓDULO DESSA VERIFICAÇÃO ESTÁ SENDO FEITO
	 
   .eBranco(eBranco),
	// SAÍDA DE UM MÓDULO QUE VERIFICA SE
	// O VALOR NA MEMÓRIA É BRANCO.
	 
   .Clk(CLK),
   .rst(RST),
	 
   .ModoOprc(MOOPMEF1),
	// MODO DE GRAVAÇÃO OU LEITURA
	// VAI SER USADO COMO UM "ADD +1"
	// NO CONTADOR DO MÍNIMO DE BARCOS
	 
   .Finished(DoneP1)
	// SINAL DE DONE.
	);
	
	MEFPlayer2 instancia_mefplayer2 (
	
    .Tgl(TgglP2),
	 // SAIDA DE TOGGLE DA MEF MAIOR
	 
    .PshBttn(),
	 // PSHBTTN COM DETECTOR DE BORDA E DEBOUNCER
	 
    .ExisteNavPts( ContDone /*&& VERIFICARPONTOS*/ ),
	 // SAÍDA DE UM MóDULO QUE VERIFICA SE PONTOS/NAVIOS != 0
	 
	 .rstAmFeito(AmProcessDone),
	 // SAÍDA DO MÓDULO DO PROCESSO DE RESET DO AMARELO!
	 
    .CorNaMemoria(eBranco),
	 // Se BRANCO, então 1, Senão entrada deve ser 0 
	 
    .rst(RST), 
    .Clk(CLK), 
	 
    .ModoMem(),
	 // Saída pra o módulo de Memória, 
	 // isso deve tá ligado à MEF maior, 
	 // já que temos a mesma saída na MEFP1
	 
	 .RegUltTiro(TglReg6BITS), 
	 // Ativa o REG de guardar a última coordenada de tiro
	 
	 .RstAmProcess(StartAmRstProc),
	 // Toggle para o módulo do reset do amarelo
	 
    .EscolhaCor(CollorSelection),
	 // Saída = 1 é vermelho, Se saída = 0, é amarelo
	 
	 .Done(DoneP2)
	 // Sinal de finalizado
	 
    //.SomaSub() Esse sinal foi reutilizado do outro, já que ser vermelho = soma/ganhar ponto.
	 
	 );
	 
	wire eBranco;
	and(eBranco, Saida[3], Saida[2]);
	
	resetDoAmarelo rstAm(
	.toggle(StartAmRstProc),
	.coord(Cord),
	.SaidaCord(Coordenada),
	.Done(AmProcessDone)
	);
	
	mux1bit Mx1(
	.A(1'b0),
	.B(1'b1),
	.slc(CollorSelection),
	.S());
	
	mux1bit Mx2(
	.A(1'b0),
	.B(1'b0),
	.slc(CollorSelection),
	.S());
	
	// TEMOS QUE PEGAR ESSA SAÍDA DOS MUXS, COLOCAR EM
	// OUTRO MUX QUE SÓ FUNCIONARÁ QUANDO O TGL DA
	// MEFP2 ESTIVER ON!
	
	wire [5:0] lastTry;
	wire [5:0] Coordenada;
	 
	// LASTTRY se trata do último tiro feito pelo atacante,
	// Isso é pra resetar o amarelo quando chegar no estado dele!
	// Devemos verificar se realmente é amarelo pra resetar, senão
	// não fazemos nada e voltamos como DONE.
	// Isso é por causa da primeira tentativa, que iniciará sem cor amarela registrada.
	
	Registrador6Bits reg_inst (
		.Q(lastTry), 
		.Inp(Cord),
		.rst(RST),
		.clk(CLK),
		.modo(TglReg6BITS));

	
	// MEF MAIOR DEVE CONTROLAR O TOGGLE e DONE
	
	contador_posicionamento Cont(
		.clk(CLK),
		.rst(RST),
		
		.Toggle(),
		// Toggle para contar +1!
		
		.pronto(ContDone),
		// Sinal de DONE
		
		.contPA(),
		.contFG(),
		.contCT(),
		.contSM()
		// CONTADORES DE CADA TIPO DE BARCO
		);
	
	VGA_interface u1(
		//INPUT
		.clk_25mhz(halfClock), 
		.reset(RST), 
		.write_enable(Enable),
		.data({Saida[3], Saida[2]}),
		.address(Coordenada), // Linha[5:3], Coluna[2:0]
	
		//OUTPUT
		.v_sync(Vsync), 
		.h_sync(Hsync),
		.R(R),
		.G(G),
		.B(B)
	);
	

endmodule