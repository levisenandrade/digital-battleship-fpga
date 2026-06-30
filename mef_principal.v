module mef_principal(
    input Clk,
    input rst,
    input concluido1,  // vem da MEFPlayer1
    input concluido2,  // vem da MEFPlayer2
    output TglP1,      // pulso único pra MEFPlayer1
    output TglP2       // pulso único pra MEFPlayer2
);
    parameter inicio    = 2'd0;
    parameter posicionamento  = 2'd1;
    parameter tiro     = 2'd2;
    parameter FimDeJogo = 2'd3;
  
    reg [1:0] state;
    reg [1:0] nextstate;

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
            inicio:         nextstate = posicionamento;
            posicionamento: if(concluido1) nextstate = tiro;
                            else nextstate = posicionamento;
            tiro:           if(concluido2) nextstate = FimDeJogo;
                            else nextstate = tiro;
            FimDeJogo:      nextstate = FimDeJogo;
            default:        nextstate = inicio;
        endcase
    end
    
    assign TglP1 = (state == inicio);
    assign TglP2 = (state == posicionamento) && concluido1;
    
endmodule
