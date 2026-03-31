`timescale 1ns / 100ps
`default_nettype none

module game_engine
#(
    parameter integer MAX_PLATFORMS = 8,
    parameter integer MAX_DOORS     = 4,

    parameter [10:0] SCR_W          = 11'd30,
    parameter [10:0] SCR_H          = 11'd20,
    parameter [10:0] PLAYER_W       = 11'd2,
    parameter [10:0] PLAYER_H       = 11'd4,

    parameter integer TICK_CNT_MAX     = 500,
    parameter signed [7:0] JUMP_VEL    = -8'sd4,
    parameter signed [7:0] GRAVITY_ACC =  8'sd1,
    parameter signed [7:0] VEL_Y_MAX   =  8'sd3
)
(
    input  wire        CLK,
    input  wire        RST,

    input  wire        KEY_LEFT,
    input  wire        KEY_RIGHT,
    input  wire        KEY_UP,
    input  wire        KEY_DOWN,

    input  wire        RESPAWN_REQ,
    input  wire [10:0] SPAWN_X,
    input  wire [10:0] SPAWN_Y,
    output reg         RESPAWN_ACK,

    input  wire [10:0] LEVEL_W,
    input  wire [10:0] LEVEL_H,

    input  wire [7:0]  PLAT_COUNT,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS,
    input  wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS,

    input  wire [7:0]  DOOR_COUNT,
    input  wire [MAX_DOORS*11-1:0] DOOR_X_BUS,
    input  wire [MAX_DOORS*11-1:0] DOOR_Y_BUS,
    input  wire [MAX_DOORS*11-1:0] DOOR_W_BUS,
    input  wire [MAX_DOORS*11-1:0] DOOR_H_BUS,
    input  wire [MAX_DOORS*4-1:0]  DOOR_TARGET_LEVEL_BUS,
    input  wire [MAX_DOORS*2-1:0]  DOOR_TARGET_ENTRY_BUS,

    output reg  [10:0] PLAYER_X,
    output reg  [10:0] PLAYER_Y,

    output wire        DOOR_HIT,
    output wire [3:0]  DOOR_TARGET_LEVEL,
    output wire [1:0]  DOOR_TARGET_ENTRY
);

    wire tick;

    game_tick
    #(
        .TICK_CNT_MAX(TICK_CNT_MAX)
    )
    u_game_tick
    (
        .clk (CLK),
        .rst (RST),
        .tick(tick)
    );

    wire [10:0] move_x;
    wire [10:0] move_y;

    player_move u_player_move
    (
        .CUR_X     (PLAYER_X),
        .CUR_Y     (PLAYER_Y),
        .KEY_LEFT  (KEY_LEFT),
        .KEY_RIGHT (KEY_RIGHT),
        .NEXT_X    (move_x),
        .NEXT_Y    (move_y)
    );

    wire on_ground_total;

    player_on_ground_list
    #(
        .MAX_PLATFORMS(MAX_PLATFORMS),
        .PLAYER_W     (PLAYER_W),
        .PLAYER_H     (PLAYER_H)
    )
    u_player_on_ground_list
    (
        .PLAYER_X   (PLAYER_X),
        .PLAYER_Y   (PLAYER_Y),
        .PLAT_COUNT (PLAT_COUNT),
        .PLAT_X_BUS (PLAT_X_BUS),
        .PLAT_Y_BUS (PLAT_Y_BUS),
        .PLAT_W_BUS (PLAT_W_BUS),
        .PLAT_H_BUS (PLAT_H_BUS),
        .ON_GROUND  (on_ground_total)
    );

    reg  signed [7:0] vel_y_reg;
    wire signed [7:0] jump_vel_y;

    player_jump
    #(
        .JUMP_VEL(JUMP_VEL)
    )
    u_player_jump
    (
        .KEY_JUMP   (KEY_UP),
        .ON_GROUND  (on_ground_total),
        .CUR_VEL_Y  (vel_y_reg),
        .NEXT_VEL_Y (jump_vel_y)
    );

    wire signed [7:0] grav_vel_y;
    wire [10:0]       grav_y;

    player_gravity
    #(
        .GRAVITY_ACC(GRAVITY_ACC),
        .VEL_Y_MAX  (VEL_Y_MAX)
    )
    u_player_gravity
    (
        .CUR_VEL_Y  (jump_vel_y),
        .CUR_Y      (move_y),
        .NEXT_VEL_Y (grav_vel_y),
        .NEXT_Y     (grav_y)
    );

    wire        hit_any;
    wire [10:0] collision_y_fixed;

    player_platform_collision_list
    #(
        .MAX_PLATFORMS(MAX_PLATFORMS),
        .PLAYER_W     (PLAYER_W),
        .PLAYER_H     (PLAYER_H)
    )
    u_player_platform_collision_list
    (
        .CUR_X      (PLAYER_X),
        .CUR_Y      (PLAYER_Y),
        .NEXT_X     (move_x),
        .NEXT_Y     (grav_y),
        .VEL_Y      (grav_vel_y),
        .PLAT_COUNT (PLAT_COUNT),
        .PLAT_X_BUS (PLAT_X_BUS),
        .PLAT_Y_BUS (PLAT_Y_BUS),
        .PLAT_W_BUS (PLAT_W_BUS),
        .PLAT_H_BUS (PLAT_H_BUS),
        .HIT_ANY    (hit_any),
        .OUT_Y      (collision_y_fixed)
    );

    wire [10:0] bounded_x;
    wire [10:0] bounded_y;

    check_boundaries
    #(
        .PLAYER_W (PLAYER_W),
        .PLAYER_H (PLAYER_H)
    )
    u_check_boundaries
    (
        .IN_X    (move_x),
        .IN_Y    (collision_y_fixed),
        .WORLD_W (LEVEL_W),
        .WORLD_H (LEVEL_H),
        .OUT_X   (bounded_x),
        .OUT_Y   (bounded_y)
    );

    door_collision_list
    #(
        .MAX_DOORS(MAX_DOORS),
        .PLAYER_W (PLAYER_W),
        .PLAYER_H (PLAYER_H)
    )
    u_door_collision_list
    (
        .PLAYER_X              (bounded_x),
        .PLAYER_Y              (bounded_y),
        .DOOR_COUNT            (DOOR_COUNT),
        .DOOR_X_BUS            (DOOR_X_BUS),
        .DOOR_Y_BUS            (DOOR_Y_BUS),
        .DOOR_W_BUS            (DOOR_W_BUS),
        .DOOR_H_BUS            (DOOR_H_BUS),
        .DOOR_TARGET_LEVEL_BUS (DOOR_TARGET_LEVEL_BUS),
        .DOOR_TARGET_ENTRY_BUS (DOOR_TARGET_ENTRY_BUS),
        .DOOR_HIT              (DOOR_HIT),
        .TARGET_LEVEL          (DOOR_TARGET_LEVEL),
        .TARGET_ENTRY          (DOOR_TARGET_ENTRY)
    );

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            PLAYER_X    <= 11'd0;
            PLAYER_Y    <= 11'd0;
            vel_y_reg   <= 8'sd0;
            RESPAWN_ACK <= 1'b0;
        end
        else begin
            RESPAWN_ACK <= 1'b0;

            if (RESPAWN_REQ) begin
                PLAYER_X    <= SPAWN_X;
                PLAYER_Y    <= SPAWN_Y;
                vel_y_reg   <= 8'sd0;
                RESPAWN_ACK <= 1'b1;
            end
            else if (tick) begin
                PLAYER_X <= bounded_x;
                PLAYER_Y <= bounded_y;

                if (hit_any)
                    vel_y_reg <= 8'sd0;
                else
                    vel_y_reg <= grav_vel_y;
            end
        end
    end

endmodule