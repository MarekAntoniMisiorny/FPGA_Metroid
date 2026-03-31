`timescale 1ns / 100ps
`default_nettype none

module level_data_mux
#(
    parameter integer MAX_PLATFORMS = 8,
    parameter integer MAX_DOORS     = 4,
    parameter [10:0] PLAYER_H       = 11'd4
)
(
    input  wire [3:0] LEVEL_ID,

    output reg [10:0] LEVEL_W,
    output reg [10:0] LEVEL_H,

    output reg [7:0] PLAT_COUNT,
    output reg [MAX_PLATFORMS*11-1:0] PLAT_X_BUS,
    output reg [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS,
    output reg [MAX_PLATFORMS*11-1:0] PLAT_W_BUS,
    output reg [MAX_PLATFORMS*11-1:0] PLAT_H_BUS,

    output reg [7:0] DOOR_COUNT,
    output reg [MAX_DOORS*11-1:0] DOOR_X_BUS,
    output reg [MAX_DOORS*11-1:0] DOOR_Y_BUS,
    output reg [MAX_DOORS*11-1:0] DOOR_W_BUS,
    output reg [MAX_DOORS*11-1:0] DOOR_H_BUS,
    output reg [MAX_DOORS*4-1:0]  DOOR_TARGET_LEVEL_BUS,
    output reg [MAX_DOORS*2-1:0]  DOOR_TARGET_ENTRY_BUS,

    output reg [10:0] SPAWN_LEFT_X,
    output reg [10:0] SPAWN_LEFT_Y,
    output reg [10:0] SPAWN_RIGHT_X,
    output reg [10:0] SPAWN_RIGHT_Y,
    output reg [10:0] SPAWN_TOP_X,
    output reg [10:0] SPAWN_TOP_Y,
    output reg [10:0] SPAWN_BOTTOM_X,
    output reg [10:0] SPAWN_BOTTOM_Y
);

    wire [10:0] l0_level_w, l0_level_h;
    wire [10:0] l1_level_w, l1_level_h;

    wire [7:0] l0_count, l1_count;
    wire [MAX_PLATFORMS*11-1:0] l0_x, l0_y, l0_w, l0_h;
    wire [MAX_PLATFORMS*11-1:0] l1_x, l1_y, l1_w, l1_h;

    wire [7:0] l0_dcount, l1_dcount;
    wire [MAX_DOORS*11-1:0] l0_dx, l0_dy, l0_dw, l0_dh;
    wire [MAX_DOORS*11-1:0] l1_dx, l1_dy, l1_dw, l1_dh;
    wire [MAX_DOORS*4-1:0]  l0_dtl, l1_dtl;
    wire [MAX_DOORS*2-1:0]  l0_dte, l1_dte;

    wire [10:0] l0_slx, l0_sly, l0_srx, l0_sry, l0_stx, l0_sty, l0_sbx, l0_sby;
    wire [10:0] l1_slx, l1_sly, l1_srx, l1_sry, l1_stx, l1_sty, l1_sbx, l1_sby;

    level0_data
    #(
        .MAX_PLATFORMS(MAX_PLATFORMS),
        .MAX_DOORS    (MAX_DOORS),
        .PLAYER_H     (PLAYER_H)
    )
    u_level0_data
    (
        .LEVEL_W               (l0_level_w),
        .LEVEL_H               (l0_level_h),

        .PLAT_COUNT            (l0_count),
        .PLAT_X_BUS            (l0_x),
        .PLAT_Y_BUS            (l0_y),
        .PLAT_W_BUS            (l0_w),
        .PLAT_H_BUS            (l0_h),

        .DOOR_COUNT            (l0_dcount),
        .DOOR_X_BUS            (l0_dx),
        .DOOR_Y_BUS            (l0_dy),
        .DOOR_W_BUS            (l0_dw),
        .DOOR_H_BUS            (l0_dh),
        .DOOR_TARGET_LEVEL_BUS (l0_dtl),
        .DOOR_TARGET_ENTRY_BUS (l0_dte),

        .SPAWN_LEFT_X          (l0_slx),
        .SPAWN_LEFT_Y          (l0_sly),
        .SPAWN_RIGHT_X         (l0_srx),
        .SPAWN_RIGHT_Y         (l0_sry),
        .SPAWN_TOP_X           (l0_stx),
        .SPAWN_TOP_Y           (l0_sty),
        .SPAWN_BOTTOM_X        (l0_sbx),
        .SPAWN_BOTTOM_Y        (l0_sby)
    );

    level1_data
    #(
        .MAX_PLATFORMS(MAX_PLATFORMS),
        .MAX_DOORS    (MAX_DOORS),
        .PLAYER_H     (PLAYER_H)
    )
    u_level1_data
    (
        .LEVEL_W               (l1_level_w),
        .LEVEL_H               (l1_level_h),

        .PLAT_COUNT            (l1_count),
        .PLAT_X_BUS            (l1_x),
        .PLAT_Y_BUS            (l1_y),
        .PLAT_W_BUS            (l1_w),
        .PLAT_H_BUS            (l1_h),

        .DOOR_COUNT            (l1_dcount),
        .DOOR_X_BUS            (l1_dx),
        .DOOR_Y_BUS            (l1_dy),
        .DOOR_W_BUS            (l1_dw),
        .DOOR_H_BUS            (l1_dh),
        .DOOR_TARGET_LEVEL_BUS (l1_dtl),
        .DOOR_TARGET_ENTRY_BUS (l1_dte),

        .SPAWN_LEFT_X          (l1_slx),
        .SPAWN_LEFT_Y          (l1_sly),
        .SPAWN_RIGHT_X         (l1_srx),
        .SPAWN_RIGHT_Y         (l1_sry),
        .SPAWN_TOP_X           (l1_stx),
        .SPAWN_TOP_Y           (l1_sty),
        .SPAWN_BOTTOM_X        (l1_sbx),
        .SPAWN_BOTTOM_Y        (l1_sby)
    );

    always @(*) begin
        case (LEVEL_ID)
            4'd1: begin
                LEVEL_W               = l1_level_w;
                LEVEL_H               = l1_level_h;

                PLAT_COUNT            = l1_count;
                PLAT_X_BUS            = l1_x;
                PLAT_Y_BUS            = l1_y;
                PLAT_W_BUS            = l1_w;
                PLAT_H_BUS            = l1_h;

                DOOR_COUNT            = l1_dcount;
                DOOR_X_BUS            = l1_dx;
                DOOR_Y_BUS            = l1_dy;
                DOOR_W_BUS            = l1_dw;
                DOOR_H_BUS            = l1_dh;
                DOOR_TARGET_LEVEL_BUS = l1_dtl;
                DOOR_TARGET_ENTRY_BUS = l1_dte;

                SPAWN_LEFT_X          = l1_slx;
                SPAWN_LEFT_Y          = l1_sly;
                SPAWN_RIGHT_X         = l1_srx;
                SPAWN_RIGHT_Y         = l1_sry;
                SPAWN_TOP_X           = l1_stx;
                SPAWN_TOP_Y           = l1_sty;
                SPAWN_BOTTOM_X        = l1_sbx;
                SPAWN_BOTTOM_Y        = l1_sby;
            end

            default: begin
                LEVEL_W               = l0_level_w;
                LEVEL_H               = l0_level_h;

                PLAT_COUNT            = l0_count;
                PLAT_X_BUS            = l0_x;
                PLAT_Y_BUS            = l0_y;
                PLAT_W_BUS            = l0_w;
                PLAT_H_BUS            = l0_h;

                DOOR_COUNT            = l0_dcount;
                DOOR_X_BUS            = l0_dx;
                DOOR_Y_BUS            = l0_dy;
                DOOR_W_BUS            = l0_dw;
                DOOR_H_BUS            = l0_dh;
                DOOR_TARGET_LEVEL_BUS = l0_dtl;
                DOOR_TARGET_ENTRY_BUS = l0_dte;

                SPAWN_LEFT_X          = l0_slx;
                SPAWN_LEFT_Y          = l0_sly;
                SPAWN_RIGHT_X         = l0_srx;
                SPAWN_RIGHT_Y         = l0_sry;
                SPAWN_TOP_X           = l0_stx;
                SPAWN_TOP_Y           = l0_sty;
                SPAWN_BOTTOM_X        = l0_sbx;
                SPAWN_BOTTOM_Y        = l0_sby;
            end
        endcase
    end

endmodule