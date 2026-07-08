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
    parameter Idle   = 3'd0;
	 parameter Ler = 3'd1;
    parameter Verif  = 3'd2;
    parameter Gravar = 3'd3;
    parameter DoneSt = 3'd4;

    reg [2:0] state;
    reg [2:0] nextstate;


	always @(posedge clk or posedge rst) begin
		if(rst) state <= Idle;
		else    state <= nextstate;
	end
	
	always @(*) begin
		case(state)
			Idle: if (toggle) nextstate = Ler;
			else nextstate = Idle;
			
			Ler: nextstate = Verif;
                
			Verif: if (info == `AMARELO) nextstate = Gravar;
			else nextstate = DoneSt;
			
			Gravar: 
			nextstate = DoneSt;
			
			DoneSt: 
                if (!toggle) nextstate = Idle; // Fica travado no DoneSt até o toggle cair
                else nextstate = DoneSt;

			default: nextstate = Idle;
		endcase
	end

	assign WriteMode = (state == Gravar);
	assign cor = (state == Gravar) ? `AZUL : info;
	assign Done = (state == DoneSt);

endmodule



