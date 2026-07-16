module MEFPlayer1(
	input PshBttn,
	input Toggle,
	input MinAtingido,
	input eBranco,
	input Clk,
	input rst,
	output ModoOprc,
	//output [3:0]Inf, A informaçao a ser colocada na memoria sera feita por outro modulo
	//output AddUm, O sinal sera ativo somente quando o ModoOprc ser 1, ou seja, estado de add informaçao
	output Finished);
	
	parameter Idle = 3'b000;
	parameter VerifQtMin = 3'b001;
	parameter RcbCord = 3'b010;
	parameter CorVerif = 3'b011;
	parameter GravarInf = 3'b100;
	parameter Done = 3'b101;
	
	reg [2:0]nextstate;
	reg [2:0]state;
	
	always @(posedge Clk, posedge rst) begin
		if(rst) state <= Idle;
		else state <= nextstate;
	end
	
	always @(*) begin
		case(state)
			Idle: if (Toggle) nextstate = VerifQtMin;
			else nextstate = Idle;
			
			VerifQtMin: if(MinAtingido) nextstate = Done;
			else nextstate = RcbCord;
			
			RcbCord: if(PshBttn) nextstate = CorVerif;
			else nextstate = RcbCord;
			
			CorVerif: if(eBranco) nextstate = RcbCord;
			else nextstate = GravarInf;
			
			GravarInf: nextstate = VerifQtMin;
			
			Done: nextstate = Idle;
			
			default: nextstate = Idle;
			
		endcase
	end
		
	assign ModoOprc = (state == GravarInf);
	assign Finished = (state == Done);
	
endmodule
