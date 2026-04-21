`timescale 1ns / 100ps
`default_nettype none

  module render_main
  #(
      parameter integer MAX_ENEMIES = 8      ,
      parameter [10:0]  SCR_W       = 11'd30 ,
      parameter [10:0]  SCR_H       = 11'd20 ,
      parameter [10:0]  PLAYER_W    = 11'd2  ,
      parameter [10:0]  PLAYER_H    = 11'd4  ,
      parameter [10:0]  ENEMY_W     = 11'd2  ,
      parameter [10:0]  ENEMY_H     = 11'd3
  )
  (
      input  wire        CLK      ,
      input  wire        RST      ,
      input  wire [10:0] H_CNT    ,
      input  wire [10:0] V_CNT    ,

      input  wire [10:0] CAMERA_X ,

      input  wire [10:0] PLAYER_X ,
      input  wire [10:0] PLAYER_Y ,

      input  wire [7:0]  ENEMY_COUNT    ,
      input  wire [MAX_ENEMIES*4-1:0]  ENEMY_TYPE_BUS ,
      input  wire [MAX_ENEMIES*11-1:0] ENEMY_X_BUS    ,
      input  wire [MAX_ENEMIES*11-1:0] ENEMY_Y_BUS    ,

      input  wire [10:0] FLOOR_X  ,
      input  wire [10:0] FLOOR_Y  ,
      input  wire [10:0] FLOOR_W  ,
      input  wire [10:0] FLOOR_H  ,

      input  wire [10:0] PLAT0_X  ,
      input  wire [10:0] PLAT0_Y  ,
      input  wire [10:0] PLAT0_W  ,
      input  wire [10:0] PLAT0_H  ,

      input  wire [10:0] PLAT1_X  ,
      input  wire [10:0] PLAT1_Y  ,
      input  wire [10:0] PLAT1_W  ,
      input  wire [10:0] PLAT1_H  ,

      input  wire [10:0] DOOR0_X  ,
      input  wire [10:0] DOOR0_Y  ,
      input  wire [10:0] DOOR0_W  ,
      input  wire [10:0] DOOR0_H  ,

      output wire [7:0]  RED      ,
      output wire [7:0]  GREEN    ,
      output wire [7:0]  BLUE
  );

  localparam [3:0] TYPE_FLOOR_BOUNCE  = 4'd1 ;
  localparam [3:0] TYPE_PLATFORM_LOOP = 4'd2 ;

  function [10:0] rect_screen_x;
      input [10:0] obj_x ;
      input [10:0] cam_x ;
      begin
          if (obj_x >= cam_x)
              rect_screen_x = obj_x - cam_x ;
          else
              rect_screen_x = 11'd0 ;
      end
  endfunction

  function [10:0] rect_screen_w;
      input [10:0] obj_x     ;
      input [10:0] obj_w     ;
      input [10:0] cam_x     ;
      reg   [10:0] cut_left  ;
      reg   [10:0] visible_w ;
      begin
          if (obj_x >= cam_x) begin
              rect_screen_w = obj_w ;
          end
          else begin
              cut_left = cam_x - obj_x ;

              if (cut_left >= obj_w)
                  rect_screen_w = 11'd0 ;
              else begin
                  visible_w     = obj_w - cut_left ;
                  rect_screen_w = visible_w ;
              end
          end
      end
  endfunction

  function [7:0] enemy_color_r;
      input [3:0] enemy_type ;
      begin
          case (enemy_type)
              TYPE_FLOOR_BOUNCE : enemy_color_r = 8'hFF ;
              TYPE_PLATFORM_LOOP: enemy_color_r = 8'hFF ;
              default           : enemy_color_r = 8'h80 ;
          endcase
      end
  endfunction

  function [7:0] enemy_color_g;
      input [3:0] enemy_type ;
      begin
          case (enemy_type)
              TYPE_FLOOR_BOUNCE : enemy_color_g = 8'h00 ;
              TYPE_PLATFORM_LOOP: enemy_color_g = 8'h40 ;
              default           : enemy_color_g = 8'h80 ;
          endcase
      end
  endfunction

  function [7:0] enemy_color_b;
      input [3:0] enemy_type ;
      begin
          case (enemy_type)
              TYPE_FLOOR_BOUNCE : enemy_color_b = 8'h00 ;
              TYPE_PLATFORM_LOOP: enemy_color_b = 8'hC0 ;
              default           : enemy_color_b = 8'h80 ;
          endcase
      end
  endfunction

  wire [10:0] floor_screen_x  ;
  wire [10:0] floor_screen_w  ;

  wire [10:0] plat0_screen_x  ;
  wire [10:0] plat0_screen_w  ;

  wire [10:0] plat1_screen_x  ;
  wire [10:0] plat1_screen_w  ;

  wire [10:0] door0_screen_x  ;
  wire [10:0] door0_screen_w  ;

  wire [10:0] player_screen_x ;
  wire [10:0] player_screen_w ;

  assign floor_screen_x  = rect_screen_x ( FLOOR_X  , CAMERA_X ) ;
  assign floor_screen_w  = rect_screen_w ( FLOOR_X  , FLOOR_W  , CAMERA_X ) ;

  assign plat0_screen_x  = rect_screen_x ( PLAT0_X  , CAMERA_X ) ;
  assign plat0_screen_w  = rect_screen_w ( PLAT0_X  , PLAT0_W  , CAMERA_X ) ;

  assign plat1_screen_x  = rect_screen_x ( PLAT1_X  , CAMERA_X ) ;
  assign plat1_screen_w  = rect_screen_w ( PLAT1_X  , PLAT1_W  , CAMERA_X ) ;

  assign door0_screen_x  = rect_screen_x ( DOOR0_X  , CAMERA_X ) ;
  assign door0_screen_w  = rect_screen_w ( DOOR0_X  , DOOR0_W  , CAMERA_X ) ;

  assign player_screen_x = rect_screen_x ( PLAYER_X , CAMERA_X ) ;
  assign player_screen_w = rect_screen_w ( PLAYER_X , PLAYER_W , CAMERA_X ) ;

  wire [7:0] s0_r ;
  wire [7:0] s0_g ;
  wire [7:0] s0_b ;

  wire [7:0] s1_r ;
  wire [7:0] s1_g ;
  wire [7:0] s1_b ;

  wire [7:0] s2_r ;
  wire [7:0] s2_g ;
  wire [7:0] s2_b ;

  wire [7:0] s3_r ;
  wire [7:0] s3_g ;
  wire [7:0] s3_b ;

  wire [7:0] s4_r ;
  wire [7:0] s4_g ;
  wire [7:0] s4_b ;

  wire [7:0] s_enemy_r [0:MAX_ENEMIES] ;
  wire [7:0] s_enemy_g [0:MAX_ENEMIES] ;
  wire [7:0] s_enemy_b [0:MAX_ENEMIES] ;

  wire [7:0] s5_r ;
  wire [7:0] s5_g ;
  wire [7:0] s5_b ;

  assign s_enemy_r[0] = s4_r ;
  assign s_enemy_g[0] = s4_g ;
  assign s_enemy_b[0] = s4_b ;

  bg_painter
  u_bg
  (
      .CLK   ( CLK   ) ,
      .RST   ( RST   ) ,
      .BG_R  ( 8'h00 ) ,
      .BG_G  ( 8'h00 ) ,
      .BG_B  ( 8'h00 ) ,
      .OUT_R ( s0_r  ) ,
      .OUT_G ( s0_g  ) ,
      .OUT_B ( s0_b  )
  );

  rect_painter
  u_floor
  (
      .CLK    ( CLK            ) ,
      .RST    ( RST            ) ,
      .H_CNT  ( H_CNT          ) ,
      .V_CNT  ( V_CNT          ) ,
      .RECT_X ( floor_screen_x ) ,
      .RECT_Y ( FLOOR_Y        ) ,
      .RECT_W ( floor_screen_w ) ,
      .RECT_H ( FLOOR_H        ) ,
      .RECT_R ( 8'hFF          ) ,
      .RECT_G ( 8'hFF          ) ,
      .RECT_B ( 8'hFF          ) ,
      .IN_R   ( s0_r           ) ,
      .IN_G   ( s0_g           ) ,
      .IN_B   ( s0_b           ) ,
      .OUT_R  ( s1_r           ) ,
      .OUT_G  ( s1_g           ) ,
      .OUT_B  ( s1_b           )
  );

  rect_painter
  u_plat0
  (
      .CLK    ( CLK            ) ,
      .RST    ( RST            ) ,
      .H_CNT  ( H_CNT          ) ,
      .V_CNT  ( V_CNT          ) ,
      .RECT_X ( plat0_screen_x ) ,
      .RECT_Y ( PLAT0_Y        ) ,
      .RECT_W ( plat0_screen_w ) ,
      .RECT_H ( PLAT0_H        ) ,
      .RECT_R ( 8'hFF          ) ,
      .RECT_G ( 8'hFF          ) ,
      .RECT_B ( 8'hFF          ) ,
      .IN_R   ( s1_r           ) ,
      .IN_G   ( s1_g           ) ,
      .IN_B   ( s1_b           ) ,
      .OUT_R  ( s2_r           ) ,
      .OUT_G  ( s2_g           ) ,
      .OUT_B  ( s2_b           )
  );

  rect_painter
  u_plat1
  (
      .CLK    ( CLK            ) ,
      .RST    ( RST            ) ,
      .H_CNT  ( H_CNT          ) ,
      .V_CNT  ( V_CNT          ) ,
      .RECT_X ( plat1_screen_x ) ,
      .RECT_Y ( PLAT1_Y        ) ,
      .RECT_W ( plat1_screen_w ) ,
      .RECT_H ( PLAT1_H        ) ,
      .RECT_R ( 8'hFF          ) ,
      .RECT_G ( 8'hFF          ) ,
      .RECT_B ( 8'hFF          ) ,
      .IN_R   ( s2_r           ) ,
      .IN_G   ( s2_g           ) ,
      .IN_B   ( s2_b           ) ,
      .OUT_R  ( s3_r           ) ,
      .OUT_G  ( s3_g           ) ,
      .OUT_B  ( s3_b           )
  );

  rect_painter
  u_door0
  (
      .CLK    ( CLK            ) ,
      .RST    ( RST            ) ,
      .H_CNT  ( H_CNT          ) ,
      .V_CNT  ( V_CNT          ) ,
      .RECT_X ( door0_screen_x ) ,
      .RECT_Y ( DOOR0_Y        ) ,
      .RECT_W ( door0_screen_w ) ,
      .RECT_H ( DOOR0_H        ) ,
      .RECT_R ( 8'h00          ) ,
      .RECT_G ( 8'h80          ) ,
      .RECT_B ( 8'hFF          ) ,
      .IN_R   ( s3_r           ) ,
      .IN_G   ( s3_g           ) ,
      .IN_B   ( s3_b           ) ,
      .OUT_R  ( s4_r           ) ,
      .OUT_G  ( s4_g           ) ,
      .OUT_B  ( s4_b           )
  );

  genvar g ;
  generate
      for (g = 0 ; g < MAX_ENEMIES ; g = g + 1) begin : GEN_ENEMY_RECT
          wire [10:0] enemy_rect_x ;
          wire [10:0] enemy_rect_w ;
          wire [7:0]  enemy_rect_r ;
          wire [7:0]  enemy_rect_g ;
          wire [7:0]  enemy_rect_b ;

          assign enemy_rect_x =
              rect_screen_x(ENEMY_X_BUS[g*11 +: 11], CAMERA_X) ;

          assign enemy_rect_w =
              rect_screen_w(ENEMY_X_BUS[g*11 +: 11], ENEMY_W, CAMERA_X) ;

          assign enemy_rect_r =
              (g < ENEMY_COUNT) ? enemy_color_r(ENEMY_TYPE_BUS[g*4 +: 4]) : 8'h00 ;

          assign enemy_rect_g =
              (g < ENEMY_COUNT) ? enemy_color_g(ENEMY_TYPE_BUS[g*4 +: 4]) : 8'h00 ;

          assign enemy_rect_b =
              (g < ENEMY_COUNT) ? enemy_color_b(ENEMY_TYPE_BUS[g*4 +: 4]) : 8'h00 ;

          rect_painter
          u_enemy_rect
          (
              .CLK    ( CLK                           ) ,
              .RST    ( RST                           ) ,
              .H_CNT  ( H_CNT                         ) ,
              .V_CNT  ( V_CNT                         ) ,
              .RECT_X ( enemy_rect_x                  ) ,
              .RECT_Y ( ENEMY_Y_BUS[g*11 +: 11]       ) ,
              .RECT_W ( (g < ENEMY_COUNT) ? enemy_rect_w : 11'd0 ) ,
              .RECT_H ( (g < ENEMY_COUNT) ? ENEMY_H   : 11'd0 ) ,
              .RECT_R ( enemy_rect_r                  ) ,
              .RECT_G ( enemy_rect_g                  ) ,
              .RECT_B ( enemy_rect_b                  ) ,
              .IN_R   ( s_enemy_r[g]                  ) ,
              .IN_G   ( s_enemy_g[g]                  ) ,
              .IN_B   ( s_enemy_b[g]                  ) ,
              .OUT_R  ( s_enemy_r[g+1]                ) ,
              .OUT_G  ( s_enemy_g[g+1]                ) ,
              .OUT_B  ( s_enemy_b[g+1]                )
          );
      end
  endgenerate

  rect_painter
  u_player
  (
      .CLK    ( CLK                   ) ,
      .RST    ( RST                   ) ,
      .H_CNT  ( H_CNT                 ) ,
      .V_CNT  ( V_CNT                 ) ,
      .RECT_X ( player_screen_x       ) ,
      .RECT_Y ( PLAYER_Y              ) ,
      .RECT_W ( player_screen_w       ) ,
      .RECT_H ( PLAYER_H              ) ,
      .RECT_R ( 8'hFF                 ) ,
      .RECT_G ( 8'hFF                 ) ,
      .RECT_B ( 8'h00                 ) ,
      .IN_R   ( s_enemy_r[MAX_ENEMIES]) ,
      .IN_G   ( s_enemy_g[MAX_ENEMIES]) ,
      .IN_B   ( s_enemy_b[MAX_ENEMIES]) ,
      .OUT_R  ( s5_r                  ) ,
      .OUT_G  ( s5_g                  ) ,
      .OUT_B  ( s5_b                  )
  );

  assign RED   = s5_r ;
  assign GREEN = s5_g ;
  assign BLUE  = s5_b ;

  endmodule