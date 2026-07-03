`include "parametros.v"

module reset_tabuleiro_azul(
    input clk,
    input rst,
    input start,
    output reg [5:0] coord,
    output [3:0] inf,
    output modo,
    output reg done
);

// modulo para inicializar/resetar o tabuleiro e pintar todo de azul
// escreve azul em todas as posições
  
reg ativo;

// agua não precsisa de tipo como as embarcações
assign inf  = {`AZUL, 2'b00};

// a memoria fica escrever apenas durante o reset
assign modo = ativo;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        coord <= 6'd0;
        ativo <= 1'b0;
        done  <= 1'b0;
    end

    else begin

        // inicia um novo reset do tabuleiro
        if(start && !ativo) begin
            ativo <= 1'b1;
            done  <= 1'b0;
            coord <= 6'd0;
        end

        // percorre todas as 64 posições do tabuleiro
        else if(ativo) begin

            if(coord == 6'd63) begin
                ativo <= 1'b0;
                done  <= 1'b1;
            end

            else begin
                coord <= coord + 6'd1;
            end
        end
    end
end

endmodule
