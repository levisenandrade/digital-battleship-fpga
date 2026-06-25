// ACHO QUE PODE DESCARTAR, HÁ COMO FAZER ISSO COM A MEF DO PLAYER 2 MAIS FACILMENTE!

module registrador_tiro(
    input clk,
    input rst,
    input [2:0] linha,
    input [2:0] coluna,
    input confirmar,

    output reg [5:0] endereco,
    output reg tiro_valido
);

reg confirmar_ant;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        endereco <= 6'b000000;
        tiro_valido <= 1'b0;
        confirmar_ant <= 1'b0;
    end

    else begin

        // Detecta borda de subida
        if(confirmar && !confirmar_ant) begin
            endereco <= {linha, coluna};
            tiro_valido <= 1'b1;
        end
        else begin
            tiro_valido <= 1'b0;
        end

        confirmar_ant <= confirmar;

    end

end

endmodule
