module contador_posicionamento(
    input clk,
    input rst,
    input Toggle,        // pushbutton qie confirma coordenada

    output reg pronto       // sinaliza que todas as casas foram posicionadas
	 output reg [2:0] contPA;
	 output reg [2:0] contFG;
	 output reg [2:0] contCT;
	 output reg [2:0] contSM;
	 
);

	parameter PORTA_AVIAO = 3'd0;
	parameter FRAGATA     = 3'd1;
	parameter CORVETA     = 3'd2;
	parameter SUBMARINO   = 3'd3;
	parameter Done = 3'd4;
	
	reg [1:0] estado;
	reg [1:0] nextstate;
	
	always @(posedge Clk, posedge rst)
		if(rst) begin 
			estado <= PORTA_AVIAO;
			contPA <= 2'd0;
			contFG <= 2'd0;
			contCT <= 2'd0;
			contSM <= 2'd0;
			pronto <= 1'd0;
			
		else state <= nextstate;

	always @(*) begin
		  // reinicia o contador ao entrar em novo estado
		  case(estado)
		  
				PORTA_AVIAO: if(contPA == 2'd4) nextstate = FRAGATA;
				else nextstate = PORTA_AVIAO;
				
				FRAGATA: if(contFG == 2'd3) nextstate = CORVETA;
				else nextstate = FRAGATA;
				
				CORVETA: if(contCT == 2'd2) nextstate = SUBMARINO;
				else nextstate = CORVETA;
				
				SUBMARINO: if(contSM == 2'd1) nextstate = Done;
				else nextstate = SUBMARINO;
				
				Done: 
				nextstate = PORTA_AVIAO;
				contPA = 2'd0;
				contFG = 2'd0;
				contCT = 2'd0;
				contSM = 2'd0;
				
				default: nextstate = PORTA_AVIAO;
		  endcase

		  // incrementa com a confirmação
		  if (Toggle) begin
				case(estado)
					
					PORTA_AVIAO: contPA = contPA + 1'b1;
					
					FRAGATA: contFG = contFG + 1'b1;
					
					CORVETA: contCT = contCT + 1'b1;
					
					SUBMARINO: contSM = contSM + 1'b1;
		  
		  assign pronto = (state == Done);
	end
endmodule

