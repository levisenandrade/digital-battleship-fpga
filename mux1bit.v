module mux1bit(S, A, B, slc);
	input A, B, slc;
	output S;
	
	wire nslc;
	wire [1:0] T;
	
	not(nslc, slc);
	
	and(T[0], nslc, A);
	and(T[1], slc, B);
	
	or(S, T[0], T[1]);

endmodule