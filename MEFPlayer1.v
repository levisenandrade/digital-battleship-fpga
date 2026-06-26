module MEFP1(
	input PshBttn,
	input MinAtingido,
	input Branco,
	input Clk,
	input rst,
	output ModoOprc,
	output reg [2:0] state,
	output reg [2:0] nextstate,
	//output [3:0]Inf, A informaçao a ser colocada na memoria sera feita por outro modulo
	//output AddUm, O sinal sera ativo somente quando o ModoOprc ser 1, ou seja, estado de add informaçao
	output Finished);
	
	parameter Idle = 3'b000;
	parameter VerifQtMin = 3'b001;
	parameter RcbCord = 3'b010;
	parameter CorVerif = 3'b011;
	parameter GravarInf = 3'b100;
	parameter Done = 3'b101;
	
	//reg [2:0]nextstate; //[2:0] state
	
	always @(posedge Clk, posedge rst)
		if(rst) state <= Idle;
		else state <= nextstate;
	end
	
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
			
			GravarInf: nextstate = VerifQtMin;
			
			Done: nextstate = Idle;
			
			default: nextstate = Idle;
			
		endcase
	end
		
	assign ModoOprc = (state == GravarInf);
	assign Finished = (state == Done);
	
endmodule
