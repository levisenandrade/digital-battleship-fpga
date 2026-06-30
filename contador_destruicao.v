`include "parametros.v"

module contador_destruicao( 
    input clk,
    input rst,
    input acerto,
    input [1:0] tipo_navio, // tipo da célula acertada

    output destPA,
	 output destFG,
	 output destCT,
	 output destSB
);

	reg [2:0] cnt_porta_avioes;
	reg [2:0] cnt_fragata;
	reg [2:0] cnt_corveta;
	reg [1:0] cnt_submarino;

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			  cnt_porta_avioes <= 3'd5;
			  cnt_fragata      <= 3'd4;
			  cnt_corveta      <= 3'd3;
			  cnt_submarino    <= 2'd2;
			  
		end 
		else if(acerto) begin
			case(tipo_navio)
				`PORTA_AVIOES:
					if(cnt_porta_avioes > 3'd0) cnt_porta_avioes <= cnt_porta_avioes - 3'd1;
				
				`FRAGATA:
					if(cnt_fragata > 3'd0) cnt_fragata <= cnt_fragata - 3'd1;

				`CORVETA:
					if(cnt_corveta > 3'd0) cnt_corveta <= cnt_corveta - 3'd1;

				`SUBMARINO:
					if(cnt_submarino > 2'd0) cnt_submarino <= cnt_submarino - 2'd1;
			endcase
		end
	end
	
	assign destPA = (cnt_porta_avioes == 3'd0);
   assign destFG = (cnt_fragata      == 3'd0);
   assign destCT = (cnt_corveta      == 3'd0);
   assign destSB = (cnt_submarino    == 2'd0);

endmodule
