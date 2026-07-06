module resetDoAmarelo(
    input clk,
    input rst,
    input toggle,
    input [1:0] info,
    output reg WriteMode,
    output reg [1:0] cor,
    output reg Done
);

	// REFAZER ESSA MEF DO GEMINI NO FORMATO QUE O PROFESSOR PEDE! - SIMEONY

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            WriteMode <= 1'b0;
            cor       <= `AZUL; 
            Done      <= 1'b0;
            state     <= 2'd0;
        end
        else begin
            case(state)
                2'd0: begin // Idle: Esperando o sinal da MEF
                    Done <= 1'b0;
                    WriteMode <= 1'b0;
                    if(toggle) state <= 2'd1; // Mux trocou a coordenada, vai esperar a RAM
                end
                
                2'd1: begin // A RAM já enviou a info certa. Pode gravar!
                    if(info == `AMARELO) begin // Substitua por 
                        WriteMode <= 1'b1;
                        cor       <= `AZUL; // Substitua por 
                    end
                    else begin
                        WriteMode <= 1'b0;
                    end
                    state <= 2'd2;
                end
                
                2'd2: begin // Finaliza e avisa a MEF
                    WriteMode <= 1'b0; // Desliga a gravação
                    Done <= 1'b1;      // Libera a MEF2
                    if(!toggle) state <= 2'd0; // Fica aqui até a MEF2 desligar o toggle
                end
                
                default: state <= 2'd0;
            endcase
        end
    end
    
endmodule