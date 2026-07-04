module contador_64_blocos(
    input clk,
    input rst,
    input pintar,              // Sinal vindo da MEF que autoriza a pintura/varredura
    output reg [5:0] q,        // Endereço do bloco atual (0 a 63)
    output reg done            // Sinal de fim de varredura (seguro)
);

    // Registrador interno para controlar o ciclo de espera do último bloco
    reg aguardando_ultima_escrita;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q                         <= 6'd0;
            done                      <= 1'b0;
            aguardando_ultima_escrita <= 1'b0;
        end
        else begin
            // Padrão: mantém o done em 0
            done <= 1'b0;

            if (pintar) begin
                if (aguardando_escrita_final) begin
                    // CICLO 3: A gravação do bloco 63 foi concluída na borda anterior.
                    // Agora resetamos o contador com segurança e avisamos a MEF.
                    q                         <= 6'd0;
                    done                      <= 1'b1;
                    aguardando_ultima_escrita <= 1'b0;
                end
                else if (q == 6'd63) begin
                    // CICLO 2: Chegamos no último bloco.
                    // Mantemos o endereço em 63 estável neste ciclo para a memória gravar.
                    // Ligamos a flag para resetar no próximo clock.
                    aguardando_ultima_escrita <= 1'b1;
                end
                else begin
                    // CICLO 1: Incremento normal de 0 até 62
                    q <= q + 6'd1;
                end
            end
            else begin
                // Se a MEF desabilitar o sinal, limpa a flag de espera
                aguardando_ultima_escrita <= 1'b0;
            end
        end
    end

endmodule