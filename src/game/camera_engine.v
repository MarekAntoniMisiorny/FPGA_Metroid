`timescale 1ns / 100ps
`default_nettype none

module camera_engine
#(
    parameter [10:0] SCR_W    = 11'd30,
    parameter [10:0] PLAYER_W = 11'd2
)
(
    input  wire        CLK,
    input  wire        RST,
    input  wire [10:0] PLAYER_X,
    input  wire [10:0] LEVEL_W,
    output reg  [10:0] CAMERA_X
);

    reg [10:0] next_camera_x;
    reg [10:0] center_offset;
    reg [10:0] max_camera_x;

    always @(*) begin
        center_offset = (SCR_W >> 1) - (PLAYER_W >> 1);

        if (LEVEL_W > SCR_W)
            max_camera_x = LEVEL_W - SCR_W;
        else
            max_camera_x = 11'd0;

        if (PLAYER_X > center_offset)
            next_camera_x = PLAYER_X - center_offset;
        else
            next_camera_x = 11'd0;

        if (next_camera_x > max_camera_x)
            next_camera_x = max_camera_x;
    end

    always @(posedge CLK or posedge RST) begin
        if (RST)
            CAMERA_X <= 11'd0;
        else
            CAMERA_X <= next_camera_x;
    end

endmodule