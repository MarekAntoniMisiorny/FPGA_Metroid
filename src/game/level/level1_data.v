`timescale 1ns / 100ps
`default_nettype none

module level1_data
#(
    parameter integer MAX_PLATFORMS = 8,
    parameter integer MAX_DOORS     = 4,
    parameter [10:0] SCR_W = 11'd30,
    parameter [10:0] SCR_H = 11'd20,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    output wire [7:0] PLAT_COUNT,
    output wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS,
    output wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS,
    output wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS,
    output wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS,

    output wire [7:0] DOOR_COUNT,
    output wire [MAX_DOORS*11-1:0] DOOR_X_BUS,
    output wire [MAX_DOORS*11-1:0] DOOR_Y_BUS,
    output wire [MAX_DOORS*11-1:0] DOOR_W_BUS,
    output wire [MAX_DOORS*11-1:0] DOOR_H_BUS,
    output wire [MAX_DOORS*4-1:0]  DOOR_TARGET_LEVEL_BUS,
    output wire [MAX_DOORS*2-1:0]  DOOR_TARGET_ENTRY_BUS,

    output wire [10:0] SPAWN_LEFT_X,
    output wire [10:0] SPAWN_LEFT_Y,
    output wire [10:0] SPAWN_RIGHT_X,
    output wire [10:0] SPAWN_RIGHT_Y,
    output wire [10:0] SPAWN_TOP_X,
    output wire [10:0] SPAWN_TOP_Y,
    output wire [10:0] SPAWN_BOTTOM_X,
    output wire [10:0] SPAWN_BOTTOM_Y
);

    localparam [10:0] FLOOR_X = 11'd0;
    localparam [10:0] FLOOR_Y = SCR_H - (SCR_H / 6);
    localparam [10:0] FLOOR_W = SCR_W;
    localparam [10:0] FLOOR_H = (SCR_H / 6);

    localparam [10:0] P0_X = SCR_W / 3;
    localparam [10:0] P0_Y = (SCR_H * 2) / 3;
    localparam [10:0] P0_W = SCR_W / 4;
    localparam [10:0] P0_H = 11'd2;

    localparam [10:0] P1_X = SCR_W / 8;
    localparam [10:0] P1_Y = SCR_H / 4;
    localparam [10:0] P1_W = SCR_W / 3;
    localparam [10:0] P1_H = 11'd2;

    localparam [10:0] D0_X = 11'd0;
    localparam [10:0] D0_Y = FLOOR_Y - (SCR_H / 6);
    localparam [10:0] D0_W = (SCR_W / 12);
    localparam [10:0] D0_H = (SCR_H / 6);

    assign PLAT_COUNT = 8'd3;

    assign PLAT_X_BUS = {
        {(MAX_PLATFORMS-3)*11{1'b0}},
        P1_X,
        P0_X,
        FLOOR_X
    };

    assign PLAT_Y_BUS = {
        {(MAX_PLATFORMS-3)*11{1'b0}},
        P1_Y,
        P0_Y,
        FLOOR_Y
    };

    assign PLAT_W_BUS = {
        {(MAX_PLATFORMS-3)*11{1'b0}},
        P1_W,
        P0_W,
        FLOOR_W
    };

    assign PLAT_H_BUS = {
        {(MAX_PLATFORMS-3)*11{1'b0}},
        P1_H,
        P0_H,
        FLOOR_H
    };

    assign DOOR_COUNT = 8'd1;

    assign DOOR_X_BUS = {
        {(MAX_DOORS-1)*11{1'b0}},
        D0_X
    };

    assign DOOR_Y_BUS = {
        {(MAX_DOORS-1)*11{1'b0}},
        D0_Y
    };

    assign DOOR_W_BUS = {
        {(MAX_DOORS-1)*11{1'b0}},
        D0_W
    };

    assign DOOR_H_BUS = {
        {(MAX_DOORS-1)*11{1'b0}},
        D0_H
    };

    assign DOOR_TARGET_LEVEL_BUS = {
        {(MAX_DOORS-1)*4{1'b0}},
        4'd0
    };

    assign DOOR_TARGET_ENTRY_BUS = {
        {(MAX_DOORS-1)*2{1'b0}},
        2'd1   // wejœcie z prawej w levelu 0
    };

    assign SPAWN_LEFT_X   = 11'd2;
    assign SPAWN_LEFT_Y   = FLOOR_Y - PLAYER_H;

    assign SPAWN_RIGHT_X  = SCR_W - (SCR_W / 8);
    assign SPAWN_RIGHT_Y  = FLOOR_Y - PLAYER_H;

    assign SPAWN_TOP_X    = SCR_W / 2;
    assign SPAWN_TOP_Y    = 11'd2;

    assign SPAWN_BOTTOM_X = SCR_W / 2;
    assign SPAWN_BOTTOM_Y = FLOOR_Y - PLAYER_H;

endmodule