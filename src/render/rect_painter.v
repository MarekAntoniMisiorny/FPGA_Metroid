`timescale 1ns / 100ps
`default_nettype none

module rect_painter
(
    input  wire        CLK,
    input  wire        RST,

    input  wire [10:0] H_CNT,
    input  wire [10:0] V_CNT,

    input  wire [10:0] RECT_X,
    input  wire [10:0] RECT_Y,
    input  wire [10:0] RECT_W,
    input  wire [10:0] RECT_H,

    input  wire [7:0]  RECT_R,
    input  wire [7:0]  RECT_G,
    input  wire [7:0]  RECT_B,

    input  wire [7:0]  IN_R,
    input  wire [7:0]  IN_G,
    input  wire [7:0]  IN_B,

    output reg  [7:0]  OUT_R,
    output reg  [7:0]  OUT_G,
    output reg  [7:0]  OUT_B
);



always @(posedge CLK or posedge RST) begin
    if (RST) begin
        OUT_R <= 8'h00;
        OUT_G <= 8'h00;
        OUT_B <= 8'h00;
    end else begin
        if (f_in_rect(H_CNT, V_CNT, RECT_X, RECT_Y, RECT_W, RECT_H)) begin
            OUT_R <= RECT_R;
            OUT_G <= RECT_G;
            OUT_B <= RECT_B;
        end else begin
            OUT_R <= IN_R;
            OUT_G <= IN_G;
            OUT_B <= IN_B;
        end
    end
end

endmodule