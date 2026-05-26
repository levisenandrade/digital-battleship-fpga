module FlipFlopD (
    input wire clk,  // Sinal de clock
    input wire rst,  // Reset assíncrono (ativo em nível alto)
    input wire d,    // Entrada de dados
    output reg q     // Saída de dados
);

    // O bloco é acionado na borda de subida do clock ou do reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0; // Zera a saída imediatamente se o reset for acionado
        end else begin
            q <= d;    // Copia a entrada D para a saída Q na borda de subida do clock
        end
    end

endmodule