module contador_destruicao(
    input clk,
    input rst,
    input acerto,
    input [1:0] tipo_navio,
    output wire destPA,
    output wire destFG,
    output wire destCT,
    output wire destSB
);

reg [2:0] cnt_porta_avioes;
reg [2:0] cnt_fragata;
reg [2:0] cnt_corveta;
reg [1:0] cnt_submarino;

// contadores

always @(posedge clk or posedge rst) begin

    if(rst) begin

        cnt_porta_avioes <= 3'd5;
        cnt_fragata      <= 3'd4;
        cnt_corveta      <= 3'd3;
        cnt_submarino    <= 2'd2;

    end

    else if(acerto) begin

        case(tipo_navio)

            `PORTA_AVIOES: begin
                if(cnt_porta_avioes > 3'd0)
                    cnt_porta_avioes <= cnt_porta_avioes - 3'd1;
            end

            `FRAGATA: begin
                if(cnt_fragata > 3'd0)
                    cnt_fragata <= cnt_fragata - 3'd1;
            end

            `CORVETA: begin
                if(cnt_corveta > 3'd0)
                    cnt_corveta <= cnt_corveta - 3'd1;
            end

            `SUBMARINO: begin
                if(cnt_submarino > 2'd0)
                    cnt_submarino <= cnt_submarino - 2'd1;
            end

            default: begin
                // Nenhuma ação
            end

        endcase

    end

end

// indicam quando cada embarcação foi destruída
	
assign destPA = (cnt_porta_avioes == 3'd0);
assign destFG = (cnt_fragata      == 3'd0);
assign destCT = (cnt_corveta      == 3'd0);
assign destSB = (cnt_submarino    == 2'd0);

endmodule
