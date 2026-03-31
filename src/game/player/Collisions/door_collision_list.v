`timescale 1ns / 100ps
`default_nettype none

module door_collision_list
#(
    parameter integer MAX_DOORS = 4,
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] PLAYER_X,
    input  wire [10:0] PLAYER_Y,

    input  wire [7:0]  DOOR_COUNT,

    input  wire [MAX_DOORS*11-1:0] DOOR_X_BUS,
    input  wire [MAX_DOORS*11-1:0] DOOR_Y_BUS,
    input  wire [MAX_DOORS*11-1:0] DOOR_W_BUS,
    input  wire [MAX_DOORS*11-1:0] DOOR_H_BUS,

    input  wire [MAX_DOORS*4-1:0]  DOOR_TARGET_LEVEL_BUS,
    input  wire [MAX_DOORS*2-1:0]  DOOR_TARGET_ENTRY_BUS,

    output reg        DOOR_HIT,
    output reg [3:0]  TARGET_LEVEL,
    output reg [1:0]  TARGET_ENTRY
);

integer i;
reg [10:0] dx, dy, dw, dh;
reg overlap_x, overlap_y;

always @(*) begin
    DOOR_HIT      = 1'b0;
    TARGET_LEVEL  = 4'd0;
    TARGET_ENTRY  = 2'd0;

    for (i = 0; i < MAX_DOORS; i = i + 1) begin
        if ((i < DOOR_COUNT) && !DOOR_HIT) begin
            dx = DOOR_X_BUS[i*11 +: 11];
            dy = DOOR_Y_BUS[i*11 +: 11];
            dw = DOOR_W_BUS[i*11 +: 11];
            dh = DOOR_H_BUS[i*11 +: 11];

            overlap_x =
                (PLAYER_X < (dx + dw)) &&
                ((PLAYER_X + PLAYER_W) > dx);

            overlap_y =
                (PLAYER_Y < (dy + dh)) &&
                ((PLAYER_Y + PLAYER_H) > dy);

            if (overlap_x && overlap_y) begin
                DOOR_HIT     = 1'b1;
                TARGET_LEVEL = DOOR_TARGET_LEVEL_BUS[i*4 +: 4];
                TARGET_ENTRY = DOOR_TARGET_ENTRY_BUS[i*2 +: 2];
            end
        end
    end
end

endmodule