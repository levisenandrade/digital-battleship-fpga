`include "parametros.v"

// TAMBÉM ACHO QUE DÁ PRA FAZER DIRETAMENTE NA LÓGICA DE IMPACTO!
// PRECISAMOS APENAS FAZER O SEGUINTE, GUARDAR A ÚLTIMA COORDENADA DO TIRO.
// GUARDAR A COORDENADA É PARA RESETAR O AMARELO DEPOIS DA PRÓXIMA JOGADA.

module verifica_tiro(
    input [3:0] celula, // casa do tabuleiro

    output reg acerto,
    output reg erro,
    output reg repetido,

    output reg [1:0] tipo_navio
	 // 00 porta-avioes 5 casas
	 // 01 fragata 4 casas
	 // 10 corveta 3 casas
	 // 11 sugbmarino 2 casas
);

wire [1:0] cor;
wire [1:0] tipo;

assign cor  = celula[3:2];
assign tipo = celula[1:0];

always @(*) begin

    acerto      = 1'b0;
    erro        = 1'b0;
    repetido    = 1'b0;
    tipo_navio  = tipo;

    case(cor)

        `BRANCO: begin
            // Navio intacto
            acerto = 1'b1;
        end

        `AZUL: begin
            // Água nunca atingida
            erro = 1'b1;
        end

        `VERMELHO: begin
            // Navio já atingido
            repetido = 1'b1;
        end

        `AMARELO: begin
            // Água já atingida
            repetido = 1'b1;
        end

    endcase

end

endmodule
