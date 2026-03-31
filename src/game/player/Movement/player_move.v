`timescale 1ns / 100ps
`default_nettype none

  module player_move
  #(
      parameter [10:0] MOVE_STEP = 11'd1
  )
  (
      input  wire [10:0] CUR_X     ,
      input  wire [10:0] CUR_Y     ,

      input  wire        KEY_LEFT  ,
      input  wire        KEY_RIGHT ,

      output reg  [10:0] NEXT_X    ,
      output reg  [10:0] NEXT_Y
  );

  always @(*) begin
      NEXT_X = CUR_X ;
      NEXT_Y = CUR_Y ;

      // =========================================================
      // ruch poziomy
      // =========================================================
      if (KEY_LEFT && !KEY_RIGHT) begin
          if (CUR_X >= MOVE_STEP)
              NEXT_X = CUR_X - MOVE_STEP ;
          else
              NEXT_X = 11'd0 ;
      end
      else if (KEY_RIGHT && !KEY_LEFT) begin
          NEXT_X = CUR_X + MOVE_STEP ;
      end
  end

  endmodule