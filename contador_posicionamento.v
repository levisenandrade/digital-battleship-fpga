module contador_posicionamento(
    input clk,
    input rst,
    input confirmar,        // pushbutton qie confirma coordenada
    input [2:0] estado,     // estado atual da MEF

    output reg pronto       // sinaliza que todas as casas foram posicionadas
);

parameter ESPERA      = 3'd0;
parameter PORTA_AVIAO = 3'd1;
parameter FRAGATA     = 3'd2;
parameter CORVETA     = 3'd3;
parameter SUBMARINO   = 3'd4;
parameter JOGO        = 3'd5;

reg [2:0] contador;
reg confirmar_ant;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        contador     <= 3'd0;
        pronto       <= 1'b0;
        confirmar_ant <= 1'b0;
    end
    else begin
        confirmar_ant <= confirmar;

        // reinicia o contador ao entrar em novo estado
        case(estado)
            PORTA_AVIAO: if(contador == 3'd0 && !pronto) contador <= 3'd5;
            FRAGATA:     if(contador == 3'd0 && !pronto) contador <= 3'd4;
            CORVETA:     if(contador == 3'd0 && !pronto) contador <= 3'd3;
            SUBMARINO:   if(contador == 3'd0 && !pronto) contador <= 3'd2;
            default:     contador <= 3'd0;
        endcase

        // decrementa na borda de subida com a confirmação
        if(confirmar && !confirmar_ant && contador > 3'd0 && !pronto) begin
            contador <= contador - 3'd1;

            if(contador == 3'd1)
                pronto <= 1'b1; // última casa confirmada
        end

        // reseta o "pronto" ao mudar de estado
        if(confirmar && !confirmar_ant && pronto)
            pronto <= 1'b0;

    end
end

endmodule

