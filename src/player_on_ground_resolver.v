`timescale 1ns / 100ps
`default_nettype none

module player_on_ground_resolver
(
    input  wire ON0,
    input  wire ON1,
    input  wire ON2,
    output wire ON_GROUND
);

assign ON_GROUND = ON0 || ON1 || ON2;

endmodule