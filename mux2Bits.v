module mux2Bits(
    input A, B, C, D,   // As 4 entradas de 1 bit
    input [1:0] slc,    // Palavra de seleção de 2 bits
    output S            // Saída final de 1 bit
);

    // Fios intermediários para conectar o primeiro estágio ao segundo
    wire mux_ab_out;
    wire mux_cd_out;

    // Primeiro estágio: filtra as 4 entradas para 2 canais usando slc[0]
    mux1bit mux_ab (
        .A(A), 
        .B(B), 
        .slc(slc[0]), 
        .S(mux_ab_out)
    );
    
    mux1bit mux_cd (
        .A(C), 
        .B(D), 
        .slc(slc[0]), 
        .S(mux_cd_out)
    );

    // Segundo estágio: escolhe o resultado final usando slc[1]
    mux1bit mux_final (
        .A(mux_ab_out), 
        .B(mux_cd_out), 
        .slc(slc[1]), 
        .S(S)
    );

endmodule