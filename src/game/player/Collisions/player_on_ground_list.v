`timescale 1ns / 100ps
`default_nettype none

module player_on_ground_list
#(
    parameter integer MAX_PLATFORMS = 8,
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] PLAYER_X,
    input  wire [10:0] PLAYER_Y,
    input  wire [7:0]  PLAT_COUNT,

    input  wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS,

    output reg ON_GROUND
);

integer i;
reg [10:0] px, py, pw, ph;
reg overlaps_x, feet_on_top;

always @(*) begin
    ON_GROUND = 1'b0;

    for (i = 0; i < MAX_PLATFORMS; i = i + 1) begin
        if (i < PLAT_COUNT) begin
            px = PLAT_X_BUS[i*11 +: 11];
            py = PLAT_Y_BUS[i*11 +: 11];
            pw = PLAT_W_BUS[i*11 +: 11];
            ph = PLAT_H_BUS[i*11 +: 11];

            overlaps_x =
                (PLAYER_X <= (px + pw - 1)) &&
((PLAYER_X + PLAYER_W - 1) >= px);

            feet_on_top =
                ((PLAYER_Y + PLAYER_H) == py);

            if (overlaps_x && feet_on_top)
                ON_GROUND = 1'b1;
        end
    end
end

endmodule