module Decoder (
    input wire clk,
    input wire rst,
    input wire [3:0] row,
    output reg [3:0] col,
    output reg [3:0] DecodeOut
);

    reg [19:0] sclk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            DecodeOut <= 4'b0000;
            sclk <= 20'b0;
        end else begin
            case (sclk)
                20'b00011000011010100000: begin // 1ms
                    col <= 4'b0111;
                    sclk <= sclk + 1;
                end
                20'b00011000011010101000: begin
                    case (row)
                        4'b0111: DecodeOut <= 4'h1; // R1 -> 1
                        4'b1011: DecodeOut <= 4'h4; // R2 -> 4
                        4'b1101: DecodeOut <= 4'h7; // R3 -> 7
                        4'b1110: DecodeOut <= 4'h0; // R4 -> 0
                    endcase
                    sclk <= sclk + 1;
                end
                20'b00110000110101000000: begin // 2ms
                    col <= 4'b1011;
                    sclk <= sclk + 1;
                end
                20'b00110000110101001000: begin
                    case (row)
                        4'b0111: DecodeOut <= 4'h2;
                        4'b1011: DecodeOut <= 4'h5;
                        4'b1101: DecodeOut <= 4'h8;
                        4'b1110: DecodeOut <= 4'hF;
                    endcase
                    sclk <= sclk + 1;
                end
                20'b01001001001111100000: begin // 3ms
                    col <= 4'b1101;
                    sclk <= sclk + 1;
                end
                20'b01001001001111101000: begin
                    case (row)
                        4'b0111: DecodeOut <= 4'h3;
                        4'b1011: DecodeOut <= 4'h6;
                        4'b1101: DecodeOut <= 4'h9;
                        4'b1110: DecodeOut <= 4'hE;
                    endcase
                    sclk <= sclk + 1;
                end
                20'b01100001101010000000: begin // 4ms
                    col <= 4'b1110;
                    sclk <= sclk + 1;
                end
                20'b01100001101010001000: begin
                    case (row)
                        4'b0111: DecodeOut <= 4'hA;
                        4'b1011: DecodeOut <= 4'hB;
                        4'b1101: DecodeOut <= 4'hC;
                        4'b1110: DecodeOut <= 4'hD;
                    endcase
                    sclk <= 20'b0; // reset scan counter
                end
                default: begin
                    sclk <= sclk + 1;
                end
            endcase
        end
    end

endmodule