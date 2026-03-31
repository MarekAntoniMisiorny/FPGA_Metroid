`timescale 1ns / 100ps
`default_nettype none

module player_move
(
    input  wire [10:0] CUR_X,
    input  wire [10:0] CUR_Y,

    input  wire        KEY_LEFT,
    input  wire        KEY_RIGHT,
    

    output reg  [10:0] NEXT_X,
    output reg  [10:0] NEXT_Y
);

always @(*) begin
    NEXT_X = CUR_X;
    NEXT_Y = CUR_Y;

    // poziom
    if (KEY_LEFT && !KEY_RIGHT) begin
        if (CUR_X > 0)
            NEXT_X = CUR_X - 11'd1;
        else
            NEXT_X = 11'd0;
    end
    else if (KEY_RIGHT && !KEY_LEFT) begin
        NEXT_X = CUR_X + 11'd1;
    end
	//NEXT_Y = CUR_Y ;
				   end
   // // pion
//    if (KEY_UP && !KEY_DOWN) begin
//        if (CUR_Y > 0)
//            NEXT_Y = CUR_Y - 11'd1;
//        else
//            NEXT_Y = 11'd0;
//    end
//    else if (KEY_DOWN && !KEY_UP) begin
//        NEXT_Y = CUR_Y + 11'd1;
//    end
//end

endmodule