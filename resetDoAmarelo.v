`include "parametros.v"

module resetDoAmarelo(
    input clk,
    input rst,
    input toggle,
    input [1:0] info,
    output WriteMode,
    output [1:0] cor,
    output Done
);

    // Definição dos Estados
    parameter Idle   = 2'd0;
    parameter Verif  = 2'd1;
    parameter Gravar = 2'd2;
    parameter DoneSt = 2'd3;

    reg [1:0] state;
    reg [1:0] nextstate;


	always @(posedge clk or posedge rst) begin
		if(rst) state <= Idle;
		else    state <= nextstate;
	end
	
	always @(*) begin
		case(state)
			Idle: if (toggle) nextstate = Verif;
			else nextstate = Idle;
                
			Verif: if (info == `AMARELO) nextstate = Gravar;
			else nextstate = DoneSt;
			
			Gravar: 
			nextstate = DoneSt;
			assign cor = `AZUL;
			
			DoneSt: nextstate = Idle;
			assign cor = info;

			default: nextstate = Idle;
		endcase
	end

	assign WriteMode = (state == Gravar);
	assign Done = (state == DoneSt);

endmodule



