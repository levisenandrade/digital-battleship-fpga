module resetDoAmarelo(
    input toggle,
    input [1:0] info, // info precisa ter 2 bits para comparar com as cores
    input clk,
    output reg WriteMode,
    output reg [1:0] cor,
    output reg Done
);

    // Variável interna para armazenar o próximo estado do Done
    reg NextDone;

    always @(posedge clk) begin
        Done <= NextDone; 

        if(toggle) begin
            if(info == `AMARELO) begin
                WriteMode <= 1'b1;
                cor       <= `AZUL;
                NextDone  <= 1'b1; // Alimenta o registrador para o próximo ciclo
                            // acho que não precisamos do NextDone aqui, poderia ser o Done logo, não é não? - Levi
                
            end
            else begin
                WriteMode <= 1'b0;
                cor       <= info;
                NextDone  <= 1'b1; // Se não for amarelo, também avança
                // mesma coisa aqwui, acho que fecha o end e logo depois vai para o Done <= 1'b1;
            end
        end
        else begin
            WriteMode <= 1'b0;
            cor       <= info;
            NextDone  <= 1'b0;
        end
    end
    
endmodule
