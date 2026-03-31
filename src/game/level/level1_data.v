`timescale 1ns / 100ps
`default_nettype none

module level1_data
#(
    parameter integer MAX_PLATFORMS = 8,
    parameter integer MAX_DOORS     = 4,
    parameter [10:0] PLAYER_H       = 11'd4
)
(
    output wire [10:0] LEVEL_W,
    output wire [10:0] LEVEL_H,

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

    // =========================================================
    // STA£Y ROZMIAR ŒWIATA LEVELU 1
    // niezale¿ny od SCR_W / SCR_H
    // =========================================================
    localparam [10:0] LEVEL_W_LOCAL = 11'd90;
    localparam [10:0] LEVEL_H_LOCAL = 11'd20;

    // =========================================================
    // Geometria levelu 1 w world-space
    // =========================================================
    localparam [10:0] FLOOR_X = 11'd0;
    localparam [10:0] FLOOR_Y = 11'd17;
    localparam [10:0] FLOOR_W = 11'd90;
    localparam [10:0] FLOOR_H = 11'd3;

    localparam [10:0] P0_X = 11'd12;
    localparam [10:0] P0_Y = 11'd11;
    localparam [10:0] P0_W = 11'd8;
    localparam [10:0] P0_H = 11'd2;

    localparam [10:0] P1_X = 11'd58;
    localparam [10:0] P1_Y = 11'd7;
    localparam [10:0] P1_W = 11'd8;
    localparam [10:0] P1_H = 11'd2;

    // drzwi powrotne blisko lewej strony
    localparam [10:0] D0_X = 11'd1;
    localparam [10:0] D0_Y = 11'd14;
    localparam [10:0] D0_W = 11'd2;
    localparam [10:0] D0_H = 11'd3;

    assign LEVEL_W = LEVEL_W_LOCAL;
    assign LEVEL_H = LEVEL_H_LOCAL;

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

    // =========================================================
    // Spawny
    // =========================================================
    assign SPAWN_LEFT_X   = 11'd2;
    assign SPAWN_LEFT_Y   = FLOOR_Y - PLAYER_H;

    assign SPAWN_RIGHT_X  = 11'd84;
    assign SPAWN_RIGHT_Y  = FLOOR_Y - PLAYER_H;

    assign SPAWN_TOP_X    = 11'd45;
    assign SPAWN_TOP_Y    = 11'd2;

    assign SPAWN_BOTTOM_X = 11'd45;
    assign SPAWN_BOTTOM_Y = FLOOR_Y - PLAYER_H;

endmodule