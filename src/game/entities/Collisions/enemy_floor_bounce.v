							`timescale 1ns / 100ps
`default_nettype none

  module enemy_floor_bounce_next
  #(
      parameter integer MAX_PLATFORMS = 8      ,
      parameter [10:0]  ENEMY_W       = 11'd2  ,
      parameter [10:0]  ENEMY_H       = 11'd3  ,
      parameter [10:0]  ENEMY_STEP    = 11'd1
  )
  (
      input  wire [10:0] CUR_X        ,
      input  wire [10:0] CUR_Y        ,
      input  wire [1:0]  CUR_DIR      ,

      input  wire [10:0] LEVEL_W      ,

      input  wire [7:0]  PLAT_COUNT   ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS ,

      output reg  [10:0] NEXT_X       ,
      output reg  [10:0] NEXT_Y       ,
      output reg  [1:0]  NEXT_DIR
  );

  localparam [1:0] DIR_RIGHT = 2'd0 ;
  localparam [1:0] DIR_LEFT  = 2'd1 ;

  integer    i                ;

  reg [10:0] cand_x           ;
  reg [1:0]  cand_dir         ;

  reg        hit_platform     ;

  reg [10:0] plat_x_i         ;
  reg [10:0] plat_y_i         ;
  reg [10:0] plat_w_i         ;
  reg [10:0] plat_h_i         ;

  reg        overlap_x        ;
  reg        overlap_y        ;

  reg [10:0] enemy_right_cand ;

  always @(*) begin
      NEXT_X           = CUR_X   ;
      NEXT_Y           = CUR_Y   ;
      NEXT_DIR         = CUR_DIR ;

      cand_x           = CUR_X   ;
      cand_dir         = CUR_DIR ;
      hit_platform     = 1'b0    ;

      enemy_right_cand = CUR_X + ENEMY_W + ENEMY_STEP ;

      if (CUR_DIR == DIR_RIGHT) begin
          if (enemy_right_cand > LEVEL_W) begin
              cand_x   = CUR_X    ;
              cand_dir = DIR_LEFT ;
          end
          else begin
              cand_x   = CUR_X + ENEMY_STEP ;
              cand_dir = DIR_RIGHT          ;
          end
      end
      else begin
          if (CUR_X < ENEMY_STEP) begin
              cand_x   = CUR_X     ;
              cand_dir = DIR_RIGHT ;
          end
          else begin
              cand_x   = CUR_X - ENEMY_STEP ;
              cand_dir = DIR_LEFT           ;
          end
      end

      for (i = 0 ; i < MAX_PLATFORMS ; i = i + 1) begin
          if (i < PLAT_COUNT) begin
              plat_x_i = PLAT_X_BUS[i*11 +: 11] ;
              plat_y_i = PLAT_Y_BUS[i*11 +: 11] ;
              plat_w_i = PLAT_W_BUS[i*11 +: 11] ;
              plat_h_i = PLAT_H_BUS[i*11 +: 11] ;

              overlap_y =
                  (CUR_Y < (plat_y_i + plat_h_i)) &&
                  ((CUR_Y + ENEMY_H) > plat_y_i) ;

              overlap_x =
                  (cand_x < (plat_x_i + plat_w_i)) &&
                  ((cand_x + ENEMY_W) > plat_x_i) ;

              if (overlap_x && overlap_y)
                  hit_platform = 1'b1 ;
          end
      end

      if (hit_platform) begin
          NEXT_X = CUR_X ;
          NEXT_Y = CUR_Y ;

          if (CUR_DIR == DIR_RIGHT)
              NEXT_DIR = DIR_LEFT ;
          else
              NEXT_DIR = DIR_RIGHT ;
      end
      else begin
          NEXT_X   = cand_x   ;
          NEXT_Y   = CUR_Y    ;
          NEXT_DIR = cand_dir ;
      end
  end

  endmodule