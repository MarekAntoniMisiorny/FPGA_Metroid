`timescale 1ns / 100ps
`default_nettype none

module player_platform_collision
#(
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] CUR_X,
    input  wire [10:0] CUR_Y,

    input  wire [10:0] NEXT_X,
    input  wire [10:0] NEXT_Y,

    input  wire signed [7:0] VEL_Y,

    input  wire [10:0] PLAT_X,
    input  wire [10:0] PLAT_Y,
    input  wire [10:0] PLAT_W,
    input  wire [10:0] PLAT_H,

    output reg  [10:0] OUT_Y,
    output reg         LAND_ON_PLATFORM
);

wire player_overlaps_x;
wire player_was_above;
wire player_hits_top;

assign player_overlaps_x =
    (NEXT_X < (PLAT_X + PLAT_W)) &&
    ((NEXT_X + PLAYER_W) > PLAT_X);

assign player_was_above =
    ((CUR_Y + PLAYER_H) <= PLAT_Y);

assign player_hits_top =
    ((NEXT_Y + PLAYER_H) >= PLAT_Y);

always @(*) begin
    OUT_Y = NEXT_Y;
    LAND_ON_PLATFORM = 1'b0;

    if (VEL_Y > 0) begin
        if (player_overlaps_x && player_was_above && player_hits_top) begin
            OUT_Y = PLAT_Y - PLAYER_H;
            LAND_ON_PLATFORM = 1'b1;
        end
    end
end

endmodule