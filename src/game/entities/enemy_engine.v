`timescale 1ns / 100ps
`default_nettype none

  module enemy_engine
  #(
      parameter integer MAX_PLATFORMS = 8      ,
      parameter [10:0]  ENEMY_W       = 11'd2  ,
      parameter [10:0]  ENEMY_H       = 11'd3  ,
      parameter [10:0]  ENEMY_STEP    = 11'd1
  )
  (
      input  wire [10:0] CUR_X        ,
      input  wire [10:0] CUR_Y        ,
      input  wire        CUR_DIR_RIGHT,

      input  wire [10:0] LEVEL_W      ,

      input  wire [7:0]  PLAT_COUNT   ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS ,

      output reg  [10:0] NEXT_X       ,
      output reg  [10:0] NEXT_Y       ,
      output reg         NEXT_DIR_RIGHT
  );

  integer    i                ;

  reg [10:0] cand_x           ;
  reg        cand_dir_right   ;

  reg        hit_platform     ;

  reg [10:0] plat_x_i         ;
  reg [10:0] plat_y_i         ;
  reg [10:0] plat_w_i         ;
  reg [10:0] plat_h_i         ;

  reg        overlap_x        ;
  reg        overlap_y        ;

  reg [10:0] enemy_right_cand ;

  always @(*) begin
      NEXT_X           = CUR_X ;
      NEXT_Y           = CUR_Y ;
      NEXT_DIR_RIGHT   = CUR_DIR_RIGHT ;

      cand_x           = CUR_X ;
      cand_dir_right   = CUR_DIR_RIGHT ;
      hit_platform     = 1'b0 ;

      enemy_right_cand = CUR_X + ENEMY_W + ENEMY_STEP ;

      // =====================================================
      // kandydat ruchu + odbicie od granic œwiata
      // =====================================================
      if (CUR_DIR_RIGHT) begin
          if (enemy_right_cand > LEVEL_W) begin
              cand_x         = CUR_X ;
              cand_dir_right = 1'b0 ;
          end
          else begin
              cand_x         = CUR_X + ENEMY_STEP ;
              cand_dir_right = 1'b1 ;
          end
      end
      else begin
          if (CUR_X < ENEMY_STEP) begin
              cand_x         = CUR_X ;
              cand_dir_right = 1'b1 ;
          end
          else begin
              cand_x         = CUR_X - ENEMY_STEP ;
              cand_dir_right = 1'b0 ;
          end
      end

      // =====================================================
      // odbicie od platform
      // =====================================================
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
          NEXT_X         = CUR_X ;
          NEXT_Y         = CUR_Y ;
          NEXT_DIR_RIGHT = !CUR_DIR_RIGHT ;
      end
      else begin
          NEXT_X         = cand_x ;
          NEXT_Y         = CUR_Y ;
          NEXT_DIR_RIGHT = cand_dir_right ;
      end
  end

  endmodule