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
      input  wire [3:0]  ENEMY_TYPE     ,
      input  wire [10:0] CUR_X          ,
      input  wire [10:0] CUR_Y          ,
      input  wire [1:0]  CUR_DIR        ,

      input  wire [10:0] LEVEL_W        ,

      input  wire [7:0]  PLAT_COUNT     ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS ,
      input  wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS ,

      input  wire [10:0] ANCHOR_X       ,
      input  wire [10:0] ANCHOR_Y       ,
      input  wire [10:0] ANCHOR_W       ,
      input  wire [10:0] ANCHOR_H       ,

      output reg  [10:0] NEXT_X         ,
      output reg  [10:0] NEXT_Y         ,
      output reg  [1:0]  NEXT_DIR
  );

  localparam [3:0] TYPE_NONE          = 4'd0 ;
  localparam [3:0] TYPE_FLOOR_BOUNCE  = 4'd1 ;
  localparam [3:0] TYPE_PLATFORM_LOOP = 4'd2 ;

  wire [10:0] floor_next_x ;
  wire [10:0] floor_next_y ;
  wire [1:0]  floor_next_dir ;

  wire [10:0] loop_next_x  ;
  wire [10:0] loop_next_y  ;
  wire [1:0]  loop_next_dir ;

  enemy_floor_bounce_next
  #(
      .MAX_PLATFORMS ( MAX_PLATFORMS ) ,
      .ENEMY_W       ( ENEMY_W       ) ,
      .ENEMY_H       ( ENEMY_H       ) ,
      .ENEMY_STEP    ( ENEMY_STEP    )
  )
  u_enemy_floor_bounce_next
  (
      .CUR_X         ( CUR_X         ) ,
      .CUR_Y         ( CUR_Y         ) ,
      .CUR_DIR       ( CUR_DIR       ) ,

      .LEVEL_W       ( LEVEL_W       ) ,

      .PLAT_COUNT    ( PLAT_COUNT    ) ,
      .PLAT_X_BUS    ( PLAT_X_BUS    ) ,
      .PLAT_Y_BUS    ( PLAT_Y_BUS    ) ,
      .PLAT_W_BUS    ( PLAT_W_BUS    ) ,
      .PLAT_H_BUS    ( PLAT_H_BUS    ) ,

      .NEXT_X        ( floor_next_x  ) ,
      .NEXT_Y        ( floor_next_y  ) ,
      .NEXT_DIR      ( floor_next_dir)
  );

  enemy_platform_loop_next
  #(
      .ENEMY_W       ( ENEMY_W      ) ,
      .ENEMY_H       ( ENEMY_H      ) ,
      .ENEMY_STEP    ( ENEMY_STEP   )
  )
  u_enemy_platform_loop_next
  (
      .CUR_X         ( CUR_X        ) ,
      .CUR_Y         ( CUR_Y        ) ,
      .CUR_DIR       ( CUR_DIR      ) ,

      .ANCHOR_X      ( ANCHOR_X     ) ,
      .ANCHOR_Y      ( ANCHOR_Y     ) ,
      .ANCHOR_W      ( ANCHOR_W     ) ,
      .ANCHOR_H      ( ANCHOR_H     ) ,

      .NEXT_X        ( loop_next_x  ) ,
      .NEXT_Y        ( loop_next_y  ) ,
      .NEXT_DIR      ( loop_next_dir)
  );

  always @(*) begin
      case (ENEMY_TYPE)
          TYPE_FLOOR_BOUNCE : begin
              NEXT_X   = floor_next_x   ;
              NEXT_Y   = floor_next_y   ;
              NEXT_DIR = floor_next_dir ;
          end

          TYPE_PLATFORM_LOOP : begin
              NEXT_X   = loop_next_x   ;
              NEXT_Y   = loop_next_y   ;
              NEXT_DIR = loop_next_dir ;
          end

          default : begin
              NEXT_X   = CUR_X   ;
              NEXT_Y   = CUR_Y   ;
              NEXT_DIR = CUR_DIR ;
          end
      endcase
  end

  endmodule