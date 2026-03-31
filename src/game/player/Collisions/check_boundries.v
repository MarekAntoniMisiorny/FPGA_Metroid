`timescale 1ns / 100ps
`default_nettype none

module check_boundaries
#(
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] IN_X,
    input  wire [10:0] IN_Y,
    input  wire [10:0] WORLD_W,
    input  wire [10:0] WORLD_H,
    output reg  [10:0] OUT_X,
    output reg  [10:0] OUT_Y
);

    reg [10:0] max_x;
    reg [10:0] max_y;

    always @(*) begin
        if (WORLD_W > PLAYER_W)
            max_x = WORLD_W - PLAYER_W;
        else
            max_x = 11'd0;

        if (WORLD_H > PLAYER_H)
            max_y = WORLD_H - PLAYER_H;
        else
            max_y = 11'd0;

        if (IN_X > max_x)
            OUT_X = max_x;
        else
            OUT_X = IN_X;

        if (IN_Y > max_y)
            OUT_Y = max_y;
        else
            OUT_Y = IN_Y;
    end

endmodule