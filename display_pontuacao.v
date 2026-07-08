module display_pontuacao(
    input [5:0] pontuacao,
    output [6:0] HEX1,
    output [6:0] HEX0
);

wire [3:0] dezena;
wire [3:0] unidade;

assign dezena = pontuacao / 10;
assign unidade = pontuacao % 10;

display_digito D0(
    .numero(unidade),
    .seg(HEX0)
);

display_digito D1(
    .numero(dezena),
    .seg(HEX1)
);

endmodule