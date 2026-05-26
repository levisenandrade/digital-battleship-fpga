module mux4Inp1Bit(S, A, B, slc);
	input [3:0] A;
	input [3:0] B;
	output [3:0] S;
	input slc;


	// Instância 0 (Trata o bit 0)
    mux1bit mux0 (
        .S(S[0]), 
        .A(A[0]), 
        .B(B[0]), 
        .slc(slc)
    );

    // Instância 1 (Trata o bit 1)
    mux1bit mux1 (
        .S(S[1]), 
        .A(A[1]), 
        .B(B[1]), 
        .slc(slc)
    );

    // Instância 2 (Trata o bit 2)
    mux1bit mux2 (
        .S(S[2]), 
        .A(A[2]), 
        .B(B[2]), 
        .slc(slc)
    );

    // Instância 3 (Trata o bit 3)
    mux1bit mux3 (
        .S(S[3]), 
        .A(A[3]), 
        .B(B[3]), 
        .slc(slc)
    );

endmodule