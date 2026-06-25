`include "parametros.v"

// MELHORAR INTEGRAÇÃO COM O MÓDULO "CONTADOR_DESTRUIÇÃO" REFORMULADO!

module contador_pontuacao(
    input clk,
    input rst,
    input acerto,
    input erro,
    input destruiu,
    input [1:0] tipo_navio,

    output reg [7:0] pontuacao,
    output reg game_over
);

// pontuação inicial
parameter PONTUACAO_INICIAL = 8'd7;

// adição ao desttruir o navio
parameter BONUS_PORTA_AVIOES = 8'd8;
parameter BONUS_FRAGATA      = 8'd6;
parameter BONUS_CORVETA      = 8'd4;
parameter BONUS_SUBMARINO    = 8'd10;

reg [7:0] bonus;

// adiação do bonus pelo tipo do navio
always @(*) begin
    case(tipo_navio)
        `PORTA_AVIOES: bonus = BONUS_PORTA_AVIOES;
        `FRAGATA:      bonus = BONUS_FRAGATA;
        `CORVETA:      bonus = BONUS_CORVETA;
        `SUBMARINO:    bonus = BONUS_SUBMARINO;
        default:       bonus = 8'd0;
    endcase
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        pontuacao <= PONTUACAO_INICIAL;
        game_over <= 1'b0;
    end
    else if(!game_over) begin

        if(destruiu) begin
            pontuacao <= pontuacao + 8'd1 + bonus;
        end
        else if(acerto) begin
            pontuacao <= pontuacao + 8'd1;
        end
        else if(erro) begin
            if(pontuacao <= 8'd1) begin
                pontuacao <= 8'd0;
                game_over <= 1'b1;
            end
            else begin
                pontuacao <= pontuacao - 8'd1;
            end
        end

    end
end

endmodule
