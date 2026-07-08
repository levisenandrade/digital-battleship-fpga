module CodMefSigToSlc(
    input A, B, C, D,
    output [1:0] Slc
);
    // Prioridade: AzulRst(D) > TgglP1(C) > TgglP2(B) > StartAmRstProc(A)
    assign Slc = (D) ? 2'b00 :
					  (A) ? 2'b11 :
					  (B) ? 2'b10 :
                 (C) ? 2'b01 :
                       2'b00; // Estado default seguro (Leitura)
endmodule