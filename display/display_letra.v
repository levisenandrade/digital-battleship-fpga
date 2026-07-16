module display_letra(
    input [2:0] letra,
    output reg [6:0] seg
);

// seg = gfedcba
// logica invertida

always @(*) begin
    case(letra)
        3'd0: seg = 7'b0001000; // A
        3'd1: seg = 7'b0000011; // b
        3'd2: seg = 7'b1000110; // C
        3'd3: seg = 7'b0100001; // d
        3'd4: seg = 7'b0000110; // E
        3'd5: seg = 7'b0001110; // F
        3'd6: seg = 7'b0010000; // G
        3'd7: seg = 7'b0001001; // H
        default: seg = 7'b1111111;
    endcase
end
  
endmodule
