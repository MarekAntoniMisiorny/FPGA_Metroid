`timescale 1ns / 100ps
`default_nettype none

module player_gravity
#(
    parameter signed [7:0] GRAVITY_ACC = 8'sd1,
    parameter signed [7:0] VEL_Y_MAX   = 8'sd3
)
(
    input  wire signed [7:0] CUR_VEL_Y,
    input  wire [10:0]       CUR_Y,

    output reg  signed [7:0] NEXT_VEL_Y,
    output reg  [10:0]       NEXT_Y
);

reg signed [7:0]  temp_vel_y;
reg signed [12:0] temp_y;
reg signed [12:0] cur_y_signed;

always @(*) begin
    cur_y_signed = $signed({1'b0, CUR_Y});

    temp_vel_y = CUR_VEL_Y + GRAVITY_ACC;
    if (temp_vel_y > VEL_Y_MAX)
        temp_vel_y = VEL_Y_MAX;

    temp_y = cur_y_signed + temp_vel_y;

    if (temp_y < 0) begin
        NEXT_Y     = 11'd0;
        NEXT_VEL_Y = 8'sd0;
    end
    else begin
        NEXT_Y     = temp_y[10:0];
        NEXT_VEL_Y = temp_vel_y;
    end
end

endmodule