module mef_principal(
    input Clk,
    input rst,
    input concluido1,  // vem da MEFPlayer1
    input concluido2,  // vem da MEFPlayer2
	 input rstFeito,
	 input limpezaFeita,
	 output startReset,
    output TglP1,      // pulso único pra MEFPlayer1
    output TglP2,       // pulso único pra MEFPlayer2
	 output startLimpeza
);
    parameter inicio    = 3'd0;
    parameter posicionamento  = 3'd1;
	 parameter limpeza = 3'd2
    parameter tiro     = 3'd3;
    parameter FimDeJogo = 3'd4;
  
    reg [2:0] state;
    reg [2:0] nextstate;

// 2 fases
// posicionamento dos navios (MEFPlayer1)
// fase de tiro (MEFPlayer2)
// após sair do reset, geraria um pulso único em TglP1 para iniciar a MEFPlayer1.
// fica no estado posicionametno até a MEFPlayer1 sinalizar "concluido1" (todos os navios foram posicionados)
// ao detectar "concluido1", gera um pulso único em TglP2 para iniciar a MEFPlayer2
// início da fase de tiro
// fica no estado tiro até a MEFPlayer2 sinalizar "concluido2" (fim de jogo)
// vai pro estado FimDeJogo e permanece nele indefinidamente

    always @(posedge Clk, posedge rst) begin
        if(rst) state <= inicio;
        else state <= nextstate;
    end
    
    always @(*) begin
        case(state)
		  
            inicio: if (rstFeito) nextstate = posicionamento;
				else nextstate = inicio;
				
            posicionamento: if(concluido1) nextstate = limpeza;
            else nextstate = posicionamento;
				
				limpeza: if(limpezaFeita) nextstate = tiro;
				else nextstate = limpeza;
				
            tiro: if(concluido2) nextstate = FimDeJogo;
            else nextstate = tiro;
				
            FimDeJogo: nextstate = FimDeJogo;
				
            default: nextstate = inicio;
        endcase
    end
    
	 assign startReset = (state == inicio);
	 assign startLimpeza = (state == limpeza);
    assign TglP1 = (state == posicionamento);
    assign TglP2 = (state == tiro);
    
endmodule
