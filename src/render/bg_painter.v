`timescale 1ns / 100ps
`default_nettype none

module bg_painter
(
    input  wire        CLK,
    input  wire        RST,
    input  wire [7:0]  BG_R,
    input  wire [7:0]  BG_G,
    input  wire [7:0]  BG_B,

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
        OUT_R <= BG_R;
        OUT_G <= BG_G;
        OUT_B <= BG_B;
    end
end

endmodule