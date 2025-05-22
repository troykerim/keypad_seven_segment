`timescale 1ns / 1ps

module kypd_top(
    input  wire       clk,
    input  wire       rst,
    inout  wire [7:0] keypad,
    output wire [6:0] segment
);

    wire [3:0] row = keypad[7:4];
    wire [3:0] col;
    wire [3:0] decode_out;

    reg  [3:0] prev_key;
    reg  [3:0] current_key;

    // Connect Decoder module (FSM-based)
    Decoder decoder_inst (
        .clk(clk),
        .rst(rst),
        .row(row),
        .col(col),
        .DecodeOut(decode_out)
    );

    // Output column pins to keypad
    assign keypad[3:0] = col;

    // Key press detection logic
    always @(posedge clk) begin
        if (rst) begin
            prev_key    <= 4'd0;
            current_key <= 4'd0;
        end else begin
            //if (decode_out != prev_key && decode_out != 4'd0) begin
            if (decode_out != prev_key) begin
                current_key <= decode_out;
            end
            prev_key <= decode_out;
        end
    end

    // Display current_key on the 7-segment display
    ssd_driver ssd_inst (
        .dig(current_key),
        .segment(segment)
    );

endmodule
