`timescale 1ns / 100ps
`default_nettype none

module game_tick
#(
    parameter integer TICK_CNT_MAX = 1000
)
(
    input  wire clk,
    input  wire rst,
    output reg  tick
);

reg [31:0] cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt  <= 32'd0;
        tick <= 1'b0;
    end
    else begin
        if (cnt >= TICK_CNT_MAX - 1) begin
            cnt  <= 32'd0;
            tick <= 1'b1;
        end
        else begin
            cnt  <= cnt + 1'b1;
            tick <= 1'b0;
        end
    end
end

endmodule