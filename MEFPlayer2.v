module MEFPlayer2(
	input Tgl, PshBttn,
	input ExisteNavPts;
	input CorNaMemoria,
	input rst, Clk,
	output ModoMem,
	output EscolhaCor,
	output SomaSub;
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
	
	always @(posedge Clk, posedge rst)
		if(rst) state <= Idle;
		else state <= nextstate;
	end
	
	always @(*)
		case(state)
			Idle: if (Tgl) nextstate = VerifNavPts;
			else nextstate = Idle;
			
			VerifNavPts: if (ExisteNavPts) nextstate = ReceberCoordUsr;
			else nextstate = Idle;
			
			ReceberCoordUsr: if (PshBttn) nextstate = ResetAmarelo;
			else nextstate = ReceberCoordUsr;
			
			ResetAmarelo: nextstate = VerificarCorMem;
			
			VerificarCorMem: if(CorNaMemoria) nextstate = Vermelho;
			else nextstate = Amarelo;
			
			Vermelho: nextstate = VerifNavPts;
			
			Amarelo: nextstate = VerifNavPts;
		endcase
	end
	
	assign ModoMem = (state == Vermelho, state == Amarelo, state == ResetAmarelo);
	assign EscolhaCor = (state == Vermelho);
	assign SomaSub = (state == Vermelho)
	
endmodule