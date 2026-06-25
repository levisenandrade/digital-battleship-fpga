`include "parametros.v"

// CORRIGIR INTEGRAÇÃO COM O MÓDULO "CONTADOR_POSICIONAMENTO" REFORMULADO

module contador_destruicao( 
    input clk,
    input rst,
    input acerto,
    input [1:0] tipo_navio, // tipo da célula acertada

    output reg destruiu,
    output reg [1:0] tipo_destruido
);

reg [2:0] cnt_porta_avioes;
reg [2:0] cnt_fragata;
reg [2:0] cnt_corveta;
reg [1:0] cnt_submarino;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt_porta_avioes <= 3'd5;
        cnt_fragata      <= 3'd4;
        cnt_corveta      <= 3'd3;
        cnt_submarino    <= 2'd2;
        destruiu         <= 1'b0;
        tipo_destruido   <= 2'b00;
    end
    else begin
        // reseta o pulso de destruição anterior a cada ciclo de clokc
        destruiu <= 1'b0;

        if(acerto) begin
            case(tipo_navio)
                `PORTA_AVIOES: begin
                    if(cnt_porta_avioes > 3'd0) begin
                        cnt_porta_avioes <= cnt_porta_avioes - 3'd1;
                        if(cnt_porta_avioes == 3'd1) begin
                            destruiu       <= 1'b1;
                            tipo_destruido <= `PORTA_AVIOES;
                        end
                    end
                end

                `FRAGATA: begin
                    if(cnt_fragata > 3'd0) begin
                        cnt_fragata <= cnt_fragata - 3'd1;
                        if(cnt_fragata == 3'd1) begin
                            destruiu       <= 1'b1;
                            tipo_destruido <= `FRAGATA;
                        end
                    end
                end

                `CORVETA: begin
                    if(cnt_corveta > 3'd0) begin
                        cnt_corveta <= cnt_corveta - 3'd1;
                        if(cnt_corveta == 3'd1) begin
                            destruiu       <= 1'b1;
                            tipo_destruido <= `CORVETA;
                        end
                    end
                end

                `SUBMARINO: begin
                    if(cnt_submarino > 2'd0) begin
                        cnt_submarino <= cnt_submarino - 2'd1;
                        if(cnt_submarino == 2'd1) begin
                            destruiu       <= 1'b1;
                            tipo_destruido <= `SUBMARINO;
                        end
                    end
                end
            endcase
        end
    end
end

endmodule
