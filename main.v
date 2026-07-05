module main(Saida, R, G, B, Vsync, Hsync, Cord, CLK, RST, Enable, HEX0, HEX1, HEX4, HEX5);
	input CLK, RST, Enable;
	input [5:0]Cord;
	output [3:0]Saida; // Valor no LED pra verificação
	output [3:0] R;
	output [3:0] G;
	output [3:0] B;
	output Vsync, Hsync;
	output [6:0] HEX0; // coluna (números 1 ~ 8)
	output [6:0] HEX1; // linha (letra A ~ H)
	output [6:0] HEX4; // pontuação unidade
	output [6:0] HEX5; // pontuação dezena
	
	wire BotaoDbc, BotaoPulso;
	wire ExisteNavPts;

	wire [1:0] TipoVerifica;
	// correção para o uso dos bits corretos
	assign TipoVerifica[0] = Saida[0];
	assign TipoVerifica[1] = Saida[1];
	
	wire game_over;
	
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
	.coord(CoordenadaFinal));
	
	// MUX DE CONTROLE GERAL DA MEMORIA ---------------------------------
	wire Modo;
	wire [3:0]Inf;
	
	mux4para1_4bits MXGeral(
    .A(4'b0100),
    .B({1'b1, 1'b1, TipoDeNavio[1], TipoDeNavio[0]}),
    .C({SaidaCorMef2[1],SaidaCorMef2[0],Saida[1], Saida[0]}),
    .D({Cor[1], Cor[0],Saida[1], Saida[0]}),
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
    .Slc(Slc));
	
	mux2para1_6bits CoordAzulRst(
    .A(Coordenada),
    .B(ContadorRst),
    .slc(AzulRst),
    .S(CoordenadaFinal));
	 
	 wire RstInicialFeito;
	 wire [5:0]ContadorRst;
	 
	 contador_64_blocos instancia_contador_64_blocos(
    .clk(CLK),
    .rst(RST),
    .pintar(AzulRst),
    .q(ContadorRst),
    .done(RstInicialFeito)
);
	
	wire [1:0]Slc;
	wire MOOPMEF1, MOOPMEF2;
	
	// MEFGERAL --------------------------------------------------------------------------------
	
	wire DoneP1, DoneP2;
	
	mef_principal MEFGERAL(
	
	.Clk(CLK),
	.rst(RST),
	
	// Esses sinais são os Dones das MEFS 1 e 2
	.concluido1(DoneP1),
	.concluido2(DoneP2),
	
	// Esses sinais serão baseados no processo de reset do sistema, ou seja, pintar tudo de azul!
	.rstFeito(RstInicialFeito),
	.startReset(AzulRst),  // Esse sinal serve de toggle pra um contador de 0-63
	// O contador vai passar em todas as casas e vai setar a cor predefinida em azul.
	// Esse sinal tbm servirá como um Slc no mux das coordenadas, sendo o valor do contador 
	// como a coordenada a ser alterada. - Simeony
	
	// Esses Sinais são os toggles de início das MEFS 1 e 2
	.TglP1(TgglP1),
	.TglP2(TgglP2));
	
	wire TgglP1, TgglP2;
	
	// MEFP1 --------------------------------------------------------------------------------
	MEFPlayer1 instancia_mefp1 (
	
	.Toggle(TgglP1),
	// Dá o start da MEF
	
   .PshBttn(BotaoPulso),
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
	 
    .PshBttn(BotaoPulso),
	 // PSHBTTN COM DETECTOR DE BORDA E DEBOUNCER
	 
    .ExisteNavPts(ExisteNavPts),
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
	 
	 .ToggleSomSUb(TGLContDest),
	 // Toggle pra contador de pontuação rodar
	 
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
	
	// CONT DESTRUIÇAO ----------------------------------------
	wire destPA, destFG, destCT, destSB;
	
	contador_destruicao contDestruicao(
    .clk(CLK),
    .rst(RST),
    .acerto(CollorSelection),
	 .tipo_navio(TipoVerifica),
    .destPA(destPA),
    .destFG(destFG),
    .destCT(destCT),
    .destSB(destSB));
	 
	 wire pulsoPA, pulsoFG, pulsoCT, pulsoSB;
	 
	 detector_borda destPAEdgDet(
    .CLK(CLK),
    .RST(RST),
    .Entrada(destPA),
    .Saida(pulsoPA));
	 
	 detector_borda destFGEdgDet(
    .CLK(CLK),
    .RST(RST),
    .Entrada(destFG),
    .Saida(pulsoFG));
	 
	 detector_borda destCTEdgDet(
    .CLK(CLK),
    .RST(RST),
    .Entrada(destCT),
    .Saida(pulsoCT));
	 
	 detector_borda destSBEdgDet(
    .CLK(CLK),
    .RST(RST),
    .Entrada(destSB),
    .Saida(pulsoSB));

	 or(PulsoDestruicao, pulsoPA, pulsoFG, pulsoCT, pulsoSB);
	// --------------------------------------------------------
	
	wire TodosBarcosDestruidos;
	and(TodosBarcosDestruidos, destPA, destFG, destCT, destSB);

	assign ExisteNavPts = !(TodosBarcosDestruidos) & !game_over; //verifica se houve game over ou se houve a destruição de todos os navios - Levi
	
	// CONT PONTUAÇAO -----------------------------------------
	wire TGLContDest;
	wire [7:0] pontuacao;
	
	contador_pontuacao contPont(
    .clk(CLK),
    .rst(RST),
    .toggle(TGLContDest),
    .acerto(CollorSelection),
    .destruiu(PulsoDestruicao), // SINAL DE DESTRUIU DURA APENAS UM CICLO DE CLOCK!
	.tipo_navio(TipoVerifica),
    .pontuacao(pontuacao),
    .game_over(game_over));
	 // --------------------------------------------------------
	
	wire WAMMODE;
	wire [1:0]Cor;
	
	resetDoAmarelo rstAm(
	.toggle(StartAmRstProc),
	.info({Saida[3], Saida[2]}),
	.clk(CLK),
	.rst(RST),
	.WriteMode(WAMMODE),
	.cor(Cor),
	.Done(AmProcessDone)
	);
	
	mux2para1_6bits SelecaoCord(
    .A(Cord),
    .B(lastTry),
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
	wire PulsoDestruicao;
	
	contador_posicionamento Cont(
		.clk(CLK),
		.rst(RST),
		
		// Toggle para contar +1! ISSO É O PUSH BUTTON COM DBC/EDGDETECTOR
		.confirmar(BotaoPulso),	
		
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
		.write_enable(Modo),
		.data({Inf[3], Inf[2]}),
		.address(CoordenadaFinal), // Linha[5:3], Coluna[2:0]
	
		//OUTPUT
		.v_sync(Vsync), 
		.h_sync(Hsync),
		.R(R),
		.G(G),
		.B(B)
	);

	debounce Dbc(
	    .CLK(CLK),
	    .RST(RST),
		.Botao(Enable), // enable é o KEY[1]
	    .Saida(BotaoDbc)
	);
	
	detector_borda EdgDet(
	    .CLK(CLK),
	    .RST(RST),
	    .Entrada(BotaoDbc),
	    .Saida(BotaoPulso)
	);
	
	/* MODULO DESNECESSÁRIO A MEF2 JÁ FAZ ESSE PROCESSO
	verifica_tiro VerTiro(
	    .celula(Saida),
	    .acerto(acerto),
	    .erro(erro),
	    .repetido(repetido),
	    .tipo_navio(TipoVerifica)
	);*/

	display_letra DisplayLinha(
	    .letra(Cord[5:3]),
	    .seg(HEX1)
	);
	
	display_numero DisplayColuna(
	    .numero({1'b0, Cord[2:0]}),
	    .seg(HEX0)
	);
	
	display_pontuacao DisplayPont(
	    .pontuacao(pontuacao[5:0]),
	    .HEX0(HEX4),
	    .HEX1(HEX5)
	);

endmodule
