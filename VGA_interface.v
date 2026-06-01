//made by Marcelo Tavares @ 2026

module VGA_interface
(
	input clk_25mhz, reset, write_enable,
	input [1:0] data,
	input [5:0] address,
	output v_sync, h_sync,
	output [3:0] R, G, B
);

	wire [9:0] x_count, y_count;
	reg in_scope, is_edge;
	reg [1:0] curr_reg;
	reg [1:0] register [63:0];
	reg [2:0] x_axis, y_axis;
	reg [10:0] x_offset;
	reg [11:0] color;
	
	integer i;
	always @(posedge clk_25mhz or posedge reset) begin
		if (reset) begin
			for (i = 0; i < 64; i = i + 1) begin
				register[i] <= 0;
			end
		end
		else begin
			if (write_enable)
				register[address] <= data;
		end
	end
	
	
	always @(*) begin	
		x_offset = {1'b0, x_count} - 11'sd80;

		is_edge = (y_count%60 == 0) | (x_offset%60 == 0) | (y_count%60 == 59) | (x_offset%60 == 59); //verifica se algum dos contadores se encontra em uma borda (grid)
		in_scope = (x_offset < 480); //verifica se os contadores estao fora do intervalo [80,480[ , nas linhas e colunas.

		x_axis = x_offset/60;
		y_axis = y_count/60;
		
		curr_reg = register[{y_axis, x_axis}];

		if (is_edge & in_scope)
			color = 12'h888; //cinza 
		else if (in_scope)
			case (curr_reg)
				2'b00: color = 12'hF00; //vermelho
				2'b01: color = 12'h00F; //azul
				2'b10: color = 12'hFF0; //amarelo
				2'b11: color = 12'hFFF; //branco
			endcase
		else
			color = 12'h000; //preto
	end
		
	VGA_driver driver(
		clk_25mhz,
		reset,
		color,
		x_count, 
		y_count,
		h_sync,
		v_sync,
		R,
		G,
		B
	);
	
endmodule