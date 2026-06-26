// Este módulo gera apenas um pulso quando o botão é pressionado.
module detector_borda(
    input CLK,
    input RST,
    input Entrada,
    output Saida
);

reg atraso;

always @(posedge CLK or posedge RST)
begin
    if(RST)
        atraso <= 1'b0;
    else
        atraso <= Entrada;
end

assign Saida = Entrada & ~atraso;

endmodule
