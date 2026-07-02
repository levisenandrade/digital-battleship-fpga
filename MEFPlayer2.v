module MEFPlayer2(
	input Tgl, PshBttn, rstAmFeito,
	input ExisteNavPts, writeEnbl,
	input CorNaMemoria,
	input rst, Clk,
	output ModoMem,
	output RegUltTiro,
	output RstAmProcess,
	output EscolhaCor,
	output Done
	//output SomaSub
);

	parameter Idle = 3'd0;
	parameter VerifNavPts = 3'd1;
	parameter ReceberCoordUsr = 3'd2;
	parameter ResetAmarelo = 3'd3;
	parameter VerificarCorMem = 3'd4;
	parameter Amarelo = 3'd5;
	parameter Vermelho = 3'd6;
	
	reg [2:0]state;
	reg [2:0]nextstate;
	
	always @(posedge Clk, posedge rst) begin
		if(rst) state <= Idle;
		else state <= nextstate;
	end
	
	always @(*) begin
		case(state)
			Idle: if (Tgl) nextstate = VerifNavPts;
			else nextstate = Idle;
			
			VerifNavPts: if (ExisteNavPts) nextstate = ReceberCoordUsr;
			else nextstate = Idle;
			
			ReceberCoordUsr: if (PshBttn) nextstate = ResetAmarelo;
			else nextstate = ReceberCoordUsr;
			
			ResetAmarelo: if (rstAmFeito) nextstate = VerificarCorMem;
			else nextstate = ResetAmarelo;
			
			VerificarCorMem: if(CorNaMemoria) nextstate = Vermelho;
			else nextstate = Amarelo;
			
			Vermelho: nextstate = VerifNavPts;
			
			Amarelo: nextstate = VerifNavPts;
			
			default: nextstate = Idle;
		endcase
	end
	
	assign ModoMem = (state == Vermelho || state == Amarelo || (state == ResetAmarelo && writeEnbl));
	assign RegUltTiro = (nextstate == ResetAmarelo);
	assign RstAmProcess = (state == ResetAmarelo);
	assign EscolhaCor = (state == Vermelho);
	assign Done = (state == VerifNavPts && !ExisteNavPts);
	assign ToggleSomSUb = (state == Vermelho || state == Amarelo);
	//assign SomaSub = (state == Vermelho);
	
endmodule