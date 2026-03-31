`timescale 1ns / 100ps
`default_nettype none

module render_main
#(
    parameter [10:0] SCR_W = 11'd30,
    parameter [10:0] SCR_H = 11'd20,
    parameter [10:0] PLAYER_W = 11'd2,
    parameter [10:0] PLAYER_H = 11'd4
)
(
    input  wire        CLK,
    input  wire        RST,
    input  wire [10:0] H_CNT,
    input  wire [10:0] V_CNT,

    input  wire [10:0] PLAYER_X,
    input  wire [10:0] PLAYER_Y,

    input  wire [10:0] FLOOR_X,
    input  wire [10:0] FLOOR_Y,
    input  wire [10:0] FLOOR_W,
    input  wire [10:0] FLOOR_H,

    input  wire [10:0] PLAT0_X,
    input  wire [10:0] PLAT0_Y,
    input  wire [10:0] PLAT0_W,
    input  wire [10:0] PLAT0_H,

    input  wire [10:0] PLAT1_X,
    input  wire [10:0] PLAT1_Y,
    input  wire [10:0] PLAT1_W,
    input  wire [10:0] PLAT1_H,

    output wire [7:0]  RED,
    output wire [7:0]  GREEN,
    output wire [7:0]  BLUE
);

    wire [7:0] s0_r, s0_g, s0_b;
    wire [7:0] s1_r, s1_g, s1_b;
    wire [7:0] s2_r, s2_g, s2_b;
    wire [7:0] s3_r, s3_g, s3_b;
    wire [7:0] s4_r, s4_g, s4_b;

    bg_painter u_bg (
        .CLK   (CLK),
        .RST   (RST),
        .BG_R  (8'h00),
        .BG_G  (8'h00),
        .BG_B  (8'h00),
        .OUT_R (s0_r),
        .OUT_G (s0_g),
        .OUT_B (s0_b)
    );

    rect_painter u_floor (
        .CLK    (CLK),
        .RST    (RST),
        .H_CNT  (H_CNT),
        .V_CNT  (V_CNT),
        .RECT_X (FLOOR_X),
        .RECT_Y (FLOOR_Y),
        .RECT_W (FLOOR_W),
        .RECT_H (FLOOR_H),
        .RECT_R (8'hFF),
        .RECT_G (8'hFF),
        .RECT_B (8'hFF),
        .IN_R   (s0_r),
        .IN_G   (s0_g),
        .IN_B   (s0_b),
        .OUT_R  (s1_r),
        .OUT_G  (s1_g),
        .OUT_B  (s1_b)
    );

    rect_painter u_plat0 (
        .CLK    (CLK),
        .RST    (RST),
        .H_CNT  (H_CNT),
        .V_CNT  (V_CNT),
        .RECT_X (PLAT0_X),
        .RECT_Y (PLAT0_Y),
        .RECT_W (PLAT0_W),
        .RECT_H (PLAT0_H),
        .RECT_R (8'hFF),
        .RECT_G (8'hFF),
        .RECT_B (8'hFF),
        .IN_R   (s1_r),
        .IN_G   (s1_g),
        .IN_B   (s1_b),
        .OUT_R  (s2_r),
        .OUT_G  (s2_g),
        .OUT_B  (s2_b)
    );

    rect_painter u_plat1 (
        .CLK    (CLK),
        .RST    (RST),
        .H_CNT  (H_CNT),
        .V_CNT  (V_CNT),
        .RECT_X (PLAT1_X),
        .RECT_Y (PLAT1_Y),
        .RECT_W (PLAT1_W),
        .RECT_H (PLAT1_H),
        .RECT_R (8'hFF),
        .RECT_G (8'hFF),
        .RECT_B (8'hFF),
        .IN_R   (s2_r),
        .IN_G   (s2_g),
        .IN_B   (s2_b),
        .OUT_R  (s3_r),
        .OUT_G  (s3_g),
        .OUT_B  (s3_b)
    );

    rect_painter u_player (
        .CLK    (CLK),
        .RST    (RST),
        .H_CNT  (H_CNT),
        .V_CNT  (V_CNT),
        .RECT_X (PLAYER_X),
        .RECT_Y (PLAYER_Y),
        .RECT_W (PLAYER_W),
        .RECT_H (PLAYER_H),
        .RECT_R (8'hFF),
        .RECT_G (8'hFF),
        .RECT_B (8'h00),
        .IN_R   (s3_r),
        .IN_G   (s3_g),
        .IN_B   (s3_b),
        .OUT_R  (s4_r),
        .OUT_G  (s4_g),
        .OUT_B  (s4_b)
    );

    assign RED   = s4_r;
    assign GREEN = s4_g;
    assign BLUE  = s4_b;

endmodule