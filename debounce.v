// Este módulo implementa um circuito de debounce, cuja finalidade é eliminar os efeitos do bounce (repique mecânico) dos botões da FPGA.

module debounce (
    input CLK,
    input RST,
    input Botao,
    output reg Saida
);

reg sincroniza1;
reg sincroniza2;
reg [19:0] contador;

always @(posedge CLK)
begin
    sincroniza1 <= Botao;
    sincroniza2 <= sincroniza1;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        contador <= 20'd0;
        Saida <= 1'b0;
    end
    else
    begin
        if(sincroniza2 == Saida)
        begin
            contador <= 20'd0;
        end
        else
        begin
            contador <= contador + 1'b1;

            if(contador == 20'd500000)
            begin
                Saida <= sincroniza2;
                contador <= 20'd0;
            end
        end
    end
end

endmodule
