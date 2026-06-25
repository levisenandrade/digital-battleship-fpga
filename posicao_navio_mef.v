`include "parametros.v"

// DESCARTÁVEL, VERSÃO FINAL ESTÁ EM "MEFPlayer1"

// prototipo MEF posiçao de navios 
module posicao_navio_mef(
	input clk,
	input rst,
	input btn, 
	
	output reg [2:0] estado
);

// codigo dos estados
parameter ESPERA      = 3'd0;
parameter PORTA_AVIAO = 3'd1;
parameter FRAGATA     = 3'd2;
parameter CORVETA     = 3'd3;
parameter SUBMARINO   = 3'd4;
parameter JOGO        = 3'd5;

reg [2:0] prox_estado; // "estado" estava declarado duas vezes, 1 vez aqui e outra vez la em cima no primeiro reg

//primeira condicao
always @(posedge clk or posedge rst)
begin
	if(rst)
		estado <= ESPERA;
	else
		estado <= prox_estado;
end

// verificaçao de estados atuais e proximos 
always @(*)
begin
	prox_estado = estado; 
	
	case(estado)
		ESPERA:
			if(btn)
				prox_estado = PORTA_AVIAO;
			
		PORTA_AVIAO:
			if(btn)
				prox_estado = FRAGATA;	
			
		FRAGATA:
			if(btn)
				prox_estado = CORVETA;	
		
		CORVETA:
			if(btn)
				prox_estado = SUBMARINO;
				
		SUBMARINO:
			if(btn)
				prox_estado = JOGO;
		
		JOGO:
			prox_estado = JOGO; //trava sem precisar da ativacao do botao
		
		default:
			prox_estado = ESPERA; //adicionmado o caso default
	endcase
end

endmodule
