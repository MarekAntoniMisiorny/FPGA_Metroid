`timescale 1ns / 100ps
`default_nettype none

module level_data
#(
    parameter [10:0] SCR_W = 11'd50,
    parameter [10:0] SCR_H = 11'd50,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [3:0] LEVEL_ID,

    output reg [10:0] FLOOR_X,
    output reg [10:0] FLOOR_Y,
    output reg [10:0] FLOOR_W,
    output reg [10:0] FLOOR_H,

    output reg [10:0] PLAT0_X,
    output reg [10:0] PLAT0_Y,
    output reg [10:0] PLAT0_W,
    output reg [10:0] PLAT0_H,

    output reg [10:0] PLAT1_X,
    output reg [10:0] PLAT1_Y,
    output reg [10:0] PLAT1_W,
    output reg [10:0] PLAT1_H,

    output reg [10:0] SPAWN_LEFT_X,
    output reg [10:0] SPAWN_LEFT_Y,
    output reg [10:0] SPAWN_RIGHT_X,
    output reg [10:0] SPAWN_RIGHT_Y,
    output reg [10:0] SPAWN_TOP_X,
    output reg [10:0] SPAWN_TOP_Y,
    output reg [10:0] SPAWN_BOTTOM_X,
    output reg [10:0] SPAWN_BOTTOM_Y
);

always @(*) begin
    case (LEVEL_ID)

        4'd0: begin
            FLOOR_X = 11'd0;
            FLOOR_Y = SCR_H - 11'd3;
            FLOOR_W = SCR_W;
            FLOOR_H = 11'd3;

            PLAT0_X = 11'd10;
            PLAT0_Y = 11'd10;
            PLAT0_W = 11'd10;
            PLAT0_H = 11'd2;

            PLAT1_X = 11'd30;
            PLAT1_Y = 11'd15;
            PLAT1_W = 11'd8;
            PLAT1_H = 11'd2;

            SPAWN_LEFT_X   = 11'd2;
            SPAWN_LEFT_Y   = FLOOR_Y - PLAYER_H;

            SPAWN_RIGHT_X  = SCR_W - 11'd4;
            SPAWN_RIGHT_Y  = FLOOR_Y - PLAYER_H;

            SPAWN_TOP_X    = SCR_W >> 1;
            SPAWN_TOP_Y    = 11'd2;

            SPAWN_BOTTOM_X = SCR_W >> 1;
            SPAWN_BOTTOM_Y = FLOOR_Y - PLAYER_H;
        end

        4'd1: begin
            FLOOR_X = 11'd0;
            FLOOR_Y = SCR_H - 11'd3;
            FLOOR_W = SCR_W;
            FLOOR_H = 11'd3;

            PLAT0_X = 11'd5;
            PLAT0_Y = 11'd30;
            PLAT0_W = 11'd8;
            PLAT0_H = 11'd2;

            PLAT1_X = 11'd25;
            PLAT1_Y = 11'd20;
            PLAT1_W = 11'd12;
            PLAT1_H = 11'd2;

            SPAWN_LEFT_X   = 11'd2;
            SPAWN_LEFT_Y   = FLOOR_Y - PLAYER_H;

            SPAWN_RIGHT_X  = SCR_W - 11'd4;
            SPAWN_RIGHT_Y  = FLOOR_Y - PLAYER_H;

            SPAWN_TOP_X    = SCR_W >> 1;
            SPAWN_TOP_Y    = 11'd2;

            SPAWN_BOTTOM_X = SCR_W >> 1;
            SPAWN_BOTTOM_Y = FLOOR_Y - PLAYER_H;
        end

        default: begin
            FLOOR_X = 11'd0;
            FLOOR_Y = SCR_H - 11'd3;
            FLOOR_W = SCR_W;
            FLOOR_H = 11'd3;

            PLAT0_X = 11'd0;
            PLAT0_Y = 11'd0;
            PLAT0_W = 11'd0;
            PLAT0_H = 11'd0;

            PLAT1_X = 11'd0;
            PLAT1_Y = 11'd0;
            PLAT1_W = 11'd0;
            PLAT1_H = 11'd0;

            SPAWN_LEFT_X   = 11'd2;
            SPAWN_LEFT_Y   = FLOOR_Y - PLAYER_H;

            SPAWN_RIGHT_X  = SCR_W - 11'd4;
            SPAWN_RIGHT_Y  = FLOOR_Y - PLAYER_H;

            SPAWN_TOP_X    = SCR_W >> 1;
            SPAWN_TOP_Y    = 11'd2;

            SPAWN_BOTTOM_X = SCR_W >> 1;
            SPAWN_BOTTOM_Y = FLOOR_Y - PLAYER_H;
        end
    endcase
end

endmodule