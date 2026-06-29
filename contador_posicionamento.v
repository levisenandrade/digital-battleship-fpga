module contador_posicionamento(
    input clk,
    input rst,
    input Toggle,        // pushbutton qie confirma coordenada

    output pronto,       // sinaliza que todas as casas foram posicionadas
	 output reg [2:0] contPA,
	 output reg [2:0] contFG,
	 output reg [2:0] contCT,
	 output reg [2:0] contSM
	 
);

	parameter PORTA_AVIAO = 3'd0;
	parameter FRAGATA     = 3'd1;
	parameter CORVETA     = 3'd2;
	parameter SUBMARINO   = 3'd3;
	parameter Done = 3'd4;
	
	reg [2:0] state;
	reg [2:0] nextstate;
	
	always @(posedge clk, posedge rst) begin
		if(rst) begin 
			state <= PORTA_AVIAO;
			contPA <= 2'd0;
			contFG <= 2'd0;
			contCT <= 2'd0;
			contSM <= 2'd0;
		end
			
		else begin
			state <= nextstate;
			// incrementa com a confirmação
			case(state) 
						
				PORTA_AVIAO: if (Toggle) contPA <= contPA + 1'b1;
				else contPA <= contPA;
						
				FRAGATA: if (Toggle) contFG <= contFG + 1'b1;
				else contFG <= contFG;
				
				CORVETA: if (Toggle) contCT <= contCT + 1'b1;
				else contCT <= contCT;
						
				SUBMARINO: if (Toggle) contSM <= contSM + 1'b1;
				else contSM <= contSM;
					
				Done: 
					contPA <= 2'd0;
					contFG <= 2'd0;
					contCT <= 2'd0;
					contSM <= 2'd0;
					
			endcase
		end
	end

	always @(*) begin
		  // reinicia o contador ao entrar em novo estado
		  case(state)
		  
				PORTA_AVIAO: if(contPA == 2'd5) nextstate = FRAGATA;
				else nextstate = PORTA_AVIAO;
				
				FRAGATA: if(contFG == 2'd4) nextstate = CORVETA;
				else nextstate = FRAGATA;
				
				CORVETA: if(contCT == 2'd3) nextstate = SUBMARINO;
				else nextstate = CORVETA;
				
				SUBMARINO: if(contSM == 2'd2) nextstate = Done;
				else nextstate = SUBMARINO;
				
				Done: 
				nextstate = PORTA_AVIAO;
				
				default: nextstate = Done;
		  endcase
	end

	assign pronto = (state == Done);
endmodule
