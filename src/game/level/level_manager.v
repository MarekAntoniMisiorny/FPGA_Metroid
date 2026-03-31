`timescale 1ns / 100ps
`default_nettype none

module level_manager
(
    input  wire        CLK,
    input  wire        RST,

    input  wire        DOOR_HIT,
    input  wire [3:0]  DOOR_TARGET_LEVEL,
    input  wire [1:0]  DOOR_TARGET_ENTRY,

    input  wire        RESPAWN_ACK,

    input  wire [10:0] SPAWN_LEFT_X,
    input  wire [10:0] SPAWN_LEFT_Y,
    input  wire [10:0] SPAWN_RIGHT_X,
    input  wire [10:0] SPAWN_RIGHT_Y,
    input  wire [10:0] SPAWN_TOP_X,
    input  wire [10:0] SPAWN_TOP_Y,
    input  wire [10:0] SPAWN_BOTTOM_X,
    input  wire [10:0] SPAWN_BOTTOM_Y,

    output reg  [3:0]  LEVEL_ID,
    output reg  [1:0]  ENTRY_ID,
    output reg  [10:0] SPAWN_X,
    output reg  [10:0] SPAWN_Y,
    output reg         RESPAWN_REQ
);

    localparam ENTRY_LEFT   = 2'd0;
    localparam ENTRY_RIGHT  = 2'd1;
    localparam ENTRY_TOP    = 2'd2;
    localparam ENTRY_BOTTOM = 2'd3;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            LEVEL_ID    <= 4'd0;
            ENTRY_ID    <= ENTRY_LEFT;
            RESPAWN_REQ <= 1'b1;
        end
        else begin
            if (DOOR_HIT && !RESPAWN_REQ) begin
                LEVEL_ID    <= DOOR_TARGET_LEVEL;
                ENTRY_ID    <= DOOR_TARGET_ENTRY;
                RESPAWN_REQ <= 1'b1;
            end
            else if (RESPAWN_REQ && RESPAWN_ACK) begin
                RESPAWN_REQ <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (ENTRY_ID)
            ENTRY_LEFT: begin
                SPAWN_X = SPAWN_LEFT_X;
                SPAWN_Y = SPAWN_LEFT_Y;
            end
            ENTRY_RIGHT: begin
                SPAWN_X = SPAWN_RIGHT_X;
                SPAWN_Y = SPAWN_RIGHT_Y;
            end
            ENTRY_TOP: begin
                SPAWN_X = SPAWN_TOP_X;
                SPAWN_Y = SPAWN_TOP_Y;
            end
            default: begin
                SPAWN_X = SPAWN_BOTTOM_X;
                SPAWN_Y = SPAWN_BOTTOM_Y;
            end
        endcase
    end

endmodule