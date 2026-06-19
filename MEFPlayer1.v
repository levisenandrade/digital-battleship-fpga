module MEFP1(
	input PshBttn,
	input MinAtingido,
	input Branco,
	input Clk,
	input rst,
	output ModoOprc,
	//output [3:0]Inf, A informaçao a ser colocada na memoria sera feita por outro modulo
	//output AddUm, O sinal sera ativo somente quando o ModoOprc ser 1, ou seja, estado de add informaçao
	output Finished);
	
	parameter Idle = 3'd0;
	parameter VerifQtMin = 3'd1;
	parameter RcbCord = 3'd2;
	parameter CorVerif = 3'd3;
	parameter GravarInf = 3'd4;
	parameter Done = 3'd5;
	
	reg [2:0] state, nextstate;
	
	always @(posedge Clk, posedge rst)
		if(rst) state <= Idle;
		else state <= nextstate;
		
	always @(*)
		case(state)
			Idle: if (PshBttn) nextstate = Idle;
			else nextstate = VerifQtMin;
			
			VerifQtMin: if(MinAtingido) nextstate = Done;
			else nextstate = RcbCord;
			
			RcbCord: if(PshBttn) nextstate = RcbCord;
			else nextstate = CorVerif;
			
			CorVerif: if(Branco) nextstate = RcbCord;
			else nextstate = GravarInf;
			
			GravarInf: if(Clk) nextstate = VerifQtMin;
			else nextstate = VerifQtMin;
			
			Done: if(Clk) nextstate = Idle;
			else nextstate = Idle;
			
			default: nextstate = Idle;
			
		endcase
		
	assign ModoOprc = (state == GravarInf);
	assign Finished = (state == Done);
	
endmodule
