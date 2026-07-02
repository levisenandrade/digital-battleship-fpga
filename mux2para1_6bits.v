module mux2para1_6bits(
    input [5:0] A,
    input [5:0] B,
    input slc,
    output [5:0] S
);

    mux1bit bit0 (
        .A(A[0]),
        .B(B[0]),
        .slc(slc),
        .S(S[0])
    );

    mux1bit bit1 (
        .A(A[1]),
        .B(B[1]),
        .slc(slc),
        .S(S[1])
    );

    mux1bit bit2 (
        .A(A[2]),
        .B(B[2]),
        .slc(slc),
        .S(S[2])
    );

    mux1bit bit3 (
        .A(A[3]),
        .B(B[3]),
        .slc(slc),
        .S(S[3])
    );

    mux1bit bit4 (
        .A(A[4]),
        .B(B[4]),
        .slc(slc),
        .S(S[4])
    );

    mux1bit bit5 (
        .A(A[5]),
        .B(B[5]),
        .slc(slc),
        .S(S[5])
    );

endmodule