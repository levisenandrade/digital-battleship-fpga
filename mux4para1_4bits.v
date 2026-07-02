module mux4para1_4bits(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] slc,
    output [3:0] S
);

    // Instancia um MUX de 1 bit para cada posição do vetor de 4 bits
    mux2Bits bit0 (
        .A(A[0]),
        .B(B[0]),
        .C(C[0]),
        .D(D[0]),
        .slc(slc),
        .S(S[0])
    );

    mux2Bits bit1 (
        .A(A[1]),
        .B(B[1]),
        .C(C[1]),
        .D(D[1]),
        .slc(slc),
        .S(S[1])
    );

    mux2Bits bit2 (
        .A(A[2]),
        .B(B[2]),
        .C(C[2]),
        .D(D[2]),
        .slc(slc),
        .S(S[2])
    );

    mux2Bits bit3 (
        .A(A[3]),
        .B(B[3]),
        .C(C[3]),
        .D(D[3]),
        .slc(slc),
        .S(S[3])
    );

endmodule