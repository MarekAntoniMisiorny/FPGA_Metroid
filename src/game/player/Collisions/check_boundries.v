`timescale 1ns / 100ps
`default_nettype none

module check_boundaries
#(
    parameter [10:0] SCR_W    = 11'd50,
    parameter [10:0] SCR_H    = 11'd50,
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] IN_X,
    input  wire [10:0] IN_Y,

    output reg  [10:0] OUT_X,
    output reg  [10:0] OUT_Y
);

always @(*) begin
    OUT_X = IN_X;
    OUT_Y = IN_Y;

    // lewa granica
    if (IN_X > (SCR_W - PLAYER_W))
        OUT_X = SCR_W - PLAYER_W;

    // prawa granica przy unsigned:
    // jeœli IN_X "przeleci" przez 0 i zrobi siê wielkie,
    // to powy¿szy warunek i tak go z³apie.
    // Dla czytelnoœci nie robimy osobnego IN_X < 0, bo to unsigned.

    // górna granica
    if (IN_Y > (SCR_H - PLAYER_H))
        OUT_Y = SCR_H - PLAYER_H;
end

endmodule