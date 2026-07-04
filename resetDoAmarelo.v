module resetDoAmarelo(
    input clk,
    input rst, // reset asisncrono adicionado
    input toggle,
    input [1:0] info,
    output reg WriteMode,
    output reg [1:0] cor,
    output reg Done
);

    reg NextDone;

    always @(posedge clk or posedge rst) begin
        if(rst) begin // ADICIONADO: bloco de reset
            WriteMode <= 1'b0;
            cor       <= `AZUL;
            Done      <= 1'b0;
            NextDone  <= 1'b0;
        end
        else begin
            Done <= NextDone;
            if(toggle) begin
                if(info == `AMARELO) begin
                    WriteMode <= 1'b1;
                    cor       <= `AZUL;
						  NextDone  <= 1'b1; // Atraso de um ciclo pra aguardar a escrita na memória - Simeony
                end
                else begin
                    WriteMode <= 1'b0;
                    cor       <= info;
						  NextDone  <= 1'b1; // BYPASS p/ caso receba toggle mas não seja amarelo(N precisa resetar) - Simeony
                end
            end
            else begin
                WriteMode <= 1'b0;
                cor       <= info;
                NextDone  <= 1'b0;
            end
        end
    end
    
endmodule
