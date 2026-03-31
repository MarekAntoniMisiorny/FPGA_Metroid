`timescale 1ns / 100ps
`default_nettype none

module player_platform_collision_resolver
(
    input  wire [10:0] NEXT_Y,

    input  wire        HIT0,
    input  wire [10:0] Y0,

    input  wire        HIT1,
    input  wire [10:0] Y1,

    input  wire        HIT2,
    input  wire [10:0] Y2,

    output reg         HIT_ANY,
    output reg  [10:0] OUT_Y
);

    always @(*) begin
        HIT_ANY = 1'b0;
        OUT_Y   = NEXT_Y;

        if (HIT0) begin
            HIT_ANY = 1'b1;
            OUT_Y   = Y0;
        end

        if (HIT1) begin
            if (!HIT_ANY || (Y1 < OUT_Y)) begin
                HIT_ANY = 1'b1;
                OUT_Y   = Y1;
            end
        end

        if (HIT2) begin
            if (!HIT_ANY || (Y2 < OUT_Y)) begin
                HIT_ANY = 1'b1;
                OUT_Y   = Y2;
            end
        end
    end

endmodule