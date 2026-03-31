`timescale 1ns / 100ps
`default_nettype none

module player_jump
#(
    parameter signed [7:0] JUMP_VEL = -8'sd8
)
(
    input  wire              KEY_JUMP,
    input  wire              ON_GROUND,
    input  wire signed [7:0] CUR_VEL_Y,

    output reg  signed [7:0] NEXT_VEL_Y
);

always @(*) begin
    NEXT_VEL_Y = CUR_VEL_Y;

    if (KEY_JUMP && ON_GROUND)
        NEXT_VEL_Y = JUMP_VEL;
end

endmodule