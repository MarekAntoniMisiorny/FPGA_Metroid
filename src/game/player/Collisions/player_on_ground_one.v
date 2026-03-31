`timescale 1ns / 100ps
`default_nettype none

module player_on_ground_one
#(
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] PLAYER_X,
    input  wire [10:0] PLAYER_Y,

    input  wire        PLAT_EN,
    input  wire [10:0] PLAT_X,
    input  wire [10:0] PLAT_Y,
    input  wire [10:0] PLAT_W,
    input  wire [10:0] PLAT_H,

    output wire        ON_GROUND
);

    wire overlaps_x;
    wire feet_on_top;

    assign overlaps_x =
        (PLAYER_X < (PLAT_X + PLAT_W)) &&
        ((PLAYER_X + PLAYER_W) > PLAT_X);

    assign feet_on_top =
        ((PLAYER_Y + PLAYER_H) == PLAT_Y);

    assign ON_GROUND = PLAT_EN && overlaps_x && feet_on_top;

endmodule