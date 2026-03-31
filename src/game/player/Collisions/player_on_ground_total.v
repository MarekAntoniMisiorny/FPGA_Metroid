`timescale 1ns / 100ps
`default_nettype none

module player_on_ground_total
#(
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] PLAYER_X,
    input  wire [10:0] PLAYER_Y,

    input  wire        ON_GROUND_BOTTOM,

    input  wire [10:0] PLAT_X,
    input  wire [10:0] PLAT_Y,
    input  wire [10:0] PLAT_W,
    input  wire [10:0] PLAT_H,

    output wire        ON_GROUND_TOTAL
);

wire on_platform_top;

assign on_platform_top =
    ((PLAYER_Y + PLAYER_H) == PLAT_Y) &&
    (PLAYER_X < (PLAT_X + PLAT_W)) &&
    ((PLAYER_X + PLAYER_W) > PLAT_X);

assign ON_GROUND_TOTAL = ON_GROUND_BOTTOM || on_platform_top;

endmodule