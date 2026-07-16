`include "parametros.v"

module contador_posicionamento(
    input clk,
    input rst,
    input confirmar,
    output reg [1:0] tipo_navio,
    output reg [2:0] casas_restantes,
    output reg fim_posicionamento

);

always @(posedge clk or posedge rst) begin

    if(rst) begin

		tipo_navio <= `PORTA_AVIOES;
		casas_restantes <= 3'd5;
		fim_posicionamento <= 1'b0;

    end

    else begin

        if(confirmar && !fim_posicionamento) begin

            // ultima casa do navio atual
            if(casas_restantes == 3'd1) begin

                case(tipo_navio)

                    `PORTA_AVIOES: begin
                        tipo_navio      <= `FRAGATA;
                        casas_restantes <= 3'd4;
                    end

                    `FRAGATA: begin
                        tipo_navio      <= `CORVETA;
                        casas_restantes <= 3'd3;
                    end

                    `CORVETA: begin
                        tipo_navio      <= `SUBMARINO;
                        casas_restantes <= 3'd2;
                    end

                    `SUBMARINO: begin
                        fim_posicionamento <= 1'b1;
                    end

                endcase

            end

            // ainda tem casas no navio atual
            else begin
                casas_restantes <= casas_restantes - 3'd1;
            end

        end

    end

end

endmodule
