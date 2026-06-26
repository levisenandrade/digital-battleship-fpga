module contador_posicionamento(
    input clk,
    input rst,
    input Toggle,

    output reg pronto,
    output reg [2:0] contPA,
    output reg [2:0] contFG,
    output reg [2:0] contCT,
    output reg [1:0] contSM
);

	parameter PORTA_AVIAO = 3'd0;
	parameter FRAGATA     = 3'd1;
	parameter CORVETA     = 3'd2;
	parameter SUBMARINO   = 3'd3;
	parameter Done        = 3'd4;
	
	reg [2:0] estado;
	reg [2:0] nextstate;
	
	always @(posedge clk or posedge rst)
		if(rst) begin 
			estado <= PORTA_AVIAO;
			contPA <= 3'd0;
			contFG <= 3'd0;
			contCT <= 3'd0;
			contSM <= 2'd0;
			pronto <= 1'b0;
		end
		else estado <= nextstate;

	always @(*) begin
		nextstate = estado;
		
		case(estado)
		
			PORTA_AVIAO: if(contPA == 3'd5) nextstate = FRAGATA;
			else nextstate = PORTA_AVIAO;
			
			FRAGATA: if(contFG == 3'd4) nextstate = CORVETA;
			else nextstate = FRAGATA;
			
			CORVETA: if(contCT == 3'd3) nextstate = SUBMARINO;
			else nextstate = CORVETA;
			
			SUBMARINO: if(contSM == 2'd2) nextstate = Done;
			else nextstate = SUBMARINO;
			
			Done: nextstate = Done;
			
			default: nextstate = PORTA_AVIAO;
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			contPA <= 3'd0;
			contFG <= 3'd0;
			contCT <= 3'd0;
			contSM <= 2'd0;
			pronto <= 1'b0;
		end
		else begin
			if(Toggle) begin
				case(estado)
					PORTA_AVIAO: if(contPA < 3'd5) contPA <= contPA + 1'b1;
					FRAGATA:     if(contFG < 3'd4) contFG <= contFG + 1'b1;
					CORVETA:     if(contCT < 3'd3) contCT <= contCT + 1'b1;
					SUBMARINO:   if(contSM < 2'd2) contSM <= contSM + 1'b1;
				endcase
			end
			
			pronto <= (nextstate == Done);
		end
	end

endmodule
