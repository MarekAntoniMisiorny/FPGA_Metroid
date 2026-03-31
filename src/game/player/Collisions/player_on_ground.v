`timescale 1ns / 100ps
`default_nettype none

module player_on_ground
#(
    parameter [10:0] SCR_H    = 11'd50,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire [10:0] PLAYER_Y,
    output wire        ON_GROUND
);

assign ON_GROUND = (PLAYER_Y >= (SCR_H - PLAYER_H ));

endmodule