`timescale 1ns / 100ps
`default_nettype none

module player_platform_collision_list
#(
    parameter integer MAX_PLATFORMS = 8,
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] CUR_X,
    input  wire [10:0] CUR_Y,

    input  wire [10:0] NEXT_X,
    input  wire [10:0] NEXT_Y,

    input  wire signed [7:0] VEL_Y,
    input  wire [7:0]  PLAT_COUNT,

    input  wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS,

    output reg        HIT_ANY,
    output reg [10:0] OUT_Y
);

integer i;
reg [10:0] px, py, pw, ph;
reg overlaps_x, was_above, hits_top;
reg [10:0] candidate_y;

always @(*) begin
    HIT_ANY = 1'b0;
    OUT_Y   = NEXT_Y;

    if (VEL_Y > 0) begin
        for (i = 0; i < MAX_PLATFORMS; i = i + 1) begin
            if (i < PLAT_COUNT) begin
                px = PLAT_X_BUS[i*11 +: 11];
                py = PLAT_Y_BUS[i*11 +: 11];
                pw = PLAT_W_BUS[i*11 +: 11];
                ph = PLAT_H_BUS[i*11 +: 11];

                overlaps_x =
                    
    (NEXT_X <= (px + pw - 1)) &&
    ((NEXT_X + PLAYER_W - 1) >= px);

                was_above =
                    ((CUR_Y + PLAYER_H) <= py);

                hits_top =
                    ((NEXT_Y + PLAYER_H) >= py);

                if (overlaps_x && was_above && hits_top) begin
                    candidate_y = py - PLAYER_H;

                    if (!HIT_ANY || (candidate_y < OUT_Y)) begin
                        HIT_ANY = 1'b1;
                        OUT_Y   = candidate_y;
                    end
                end
            end
        end
    end
end

endmodule