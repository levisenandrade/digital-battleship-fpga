module main(Saida, R, G, B, Vsync, Hsync, Cord, CLK, RST, Enable);
	input CLK, RST, Enable;
	input [5:0]Cord;
	output [3:0]Saida; // Valor no LED pra verificação
	output [3:0] R;
	output [3:0] G;
	output [3:0] B;
	output Vsync, Hsync;

	// sinal de game over
	
	wire game_over; // pontos chegam a 0 - Levi
	wire destPA, destFG, destCT, destSB; // todos os navios foram destruidos - Levi
	
	assign ExisteNavPts = !(destPA & destFG & destCT & destSB) & !game_over; //verifica se houve game over ou se houve a destruição de todos os navios - Levi
	
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
	.inf(Inf),
	.modo(Modo),
	.coord(Coordenada));
	
	// MUX DE CONTROLE GERAL DA MEMORIA ---------------------------------
	wire Modo;
	wire [3:0]Inf;
	
	mux4para1_4bits MXGeral(
    .A(4'b0100),
    .B({1'b1, 1'b1, TipoDeNavio[1], TipoDeNavio[0]}),
    .C({SaidaCorMef2[1],SaidaCorMef2[0],Saida[1], Saida[0]}),
    .D(Cor[1], Cor[0],Saida[1], Saida[0]),
    .slc(Slc),
    .S(Inf));
	 
	 mux2Bits MXMOOP(
    .A(1'b1),
    .B(MOOPMEF1),
    .C(MOOPMEF2),
    .D(1'b0),
    .slc(Slc),
    .S(Modo));
	 
	 CodMefSigToSlc SignToSLC(
    .A(StartAmRstProc),
    .B(TgglP2),
    .C(TgglP1),
	 .D(AzulRst),
    .Slc(Slc)
	);
	
	wire [1:0]Slc;
	wire MOOPMEF1, MOOPMEF2;
	// -------------------------------------------------------------------

	
	// MEFGERAL --------------------------------------------------------------------------------
	
	wire DoneP1, DoneP2;
	
	mef_principal MEFGERAL(
	
	.Clk(CLK),
	.rst(RST),
	
	// Esses sinais são os Dones das MEFS 1 e 2
	.concluido1(DoneP1),
	.concluido2(DoneP2),
	
	// Esses sinais serão baseados no processo de reset do sistema, ou seja, pintar tudo de azul!
	.rstFeito( ),
	.startReset(AzulRst),
	
	// Esses Sinais são os toggles de início das MEFS 1 e 2
	.TglP1(TgglP1),
	.TglP2(TgglP2));
	
	wire TgglP1, TgglP2;
	
	
	// MEFP1 --------------------------------------------------------------------------------
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
	
	
	// MEFP1 --------------------------------------------------------------------------------
	MEFPlayer2 instancia_mefplayer2 (
	
    .Tgl(TgglP2),
	 // SAIDA DE TOGGLE DA MEF MAIOR
	 
    .PshBttn(),
	 // PSHBTTN COM DETECTOR DE BORDA E DEBOUNCER
	 
    .ExisteNavPts(/*EXISTEMNAVIOS && VERIFICARPONTOS*/ ),
	 // SAÍDA DE UM MóDULO QUE VERIFICA SE PONTOS/NAVIOS != 0
	 
	 .rstAmFeito(AmProcessDone),
	 // SAÍDA DO MÓDULO DO PROCESSO DE RESET DO AMARELO!
	 
    .CorNaMemoria(eBranco),
	 // Se BRANCO, então 1, Senão entrada deve ser 0 
	 
	 .writeEnbl(WAMMODE),
	 
    .rst(RST), 
    .Clk(CLK), 
	 
    .ModoMem(MOOPMEF2),
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
	
	wire WAMMODE;
	wire [1:0]Cor;
	
	resetDoAmarelo rstAm(
	.toggle(StartAmRstProc),
	.info({Saida[3], Saida[2]}),
	.clk(CLK),
	.WriteMode(WAMMODE),
	.cor(Cor),
	.Done(AmProcessDone)
	);
	
	mux2para1_6bits SelecaoCord(
    .A(Cord),
    .B(CordAmRst),
    .slc(StartAmRstProc),
    .S(Coordenada)
	);
	
	// Seleção de cor MEF2 ----------------------------------
	
	wire [1:0]SaidaCorMef2;
	
	mux1bit Mx1(
	.A(1'b1),
	.B(1'b0),
	.slc(CollorSelection),
	.S(SaidaCorMef2[1]));
	
	mux1bit Mx2(
	.A(1'b0),
	.B(1'b0),
	.slc(CollorSelection),
	.S(SaidaCorMef2[0]));
	
	// ------------------------------------------------------
	
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
	
	wire [1:0]TipoDeNavio;
	
	contador_posicionamento Cont(
		.clk(CLK),
		.rst(RST),
		
		// Toggle para contar +1!
		.confirmar(),	
		
		.tipo_navio(TipoDeNavio),
		
		// Sinal de DONE
		.fim_posicionamento(ContDone),
		
		
		.casas_restantes()
		//Saida sANTIGAS
		//.contPA(),
		//.contFG(),
		//.contCT(),
		//.contSM()
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
