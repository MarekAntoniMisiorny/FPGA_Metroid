`timescale 1ns / 100ps
`default_nettype none

  module pong_main
  #(
      parameter integer MAX_PLATFORMS = 8       ,
      parameter integer MAX_DOORS     = 4       ,

      parameter [10:0]  SCR_W         = 11'd30  ,
      parameter [10:0]  SCR_H         = 11'd20  ,

      parameter [10:0]  PLAYER_W      = 11'd2   ,
      parameter [10:0]  PLAYER_H      = 11'd4   ,

      parameter [10:0]  ENEMY_W       = 11'd2   ,
      parameter [10:0]  ENEMY_H       = 11'd3   ,
      parameter integer ENEMY_TICK_DIV = 4      ,

      parameter integer TICK_CNT_MAX  = 500
  )
  (
      input  wire        CLK      ,
      input  wire        RST      ,

      input  wire [10:0] H_CNT    ,
      input  wire [10:0] V_CNT    ,

      output wire [7:0]  RED      ,
      output wire [7:0]  GREEN    ,
      output wire [7:0]  BLUE     ,

      input  wire        EncA_QA  ,
      input  wire        EncA_QB  ,
      input  wire        EncB_QA  ,
      input  wire        EncB_QB  ,

      output wire [3:0]  LED
  );

  // =========================================================
  // auto-skalowanie ruchu i fizyki od ekranu gry
  // =========================================================
  localparam [10:0] MOVE_STEP_LOCAL =
      (SCR_W / 11'd30 > 0) ? (SCR_W / 11'd30) : 11'd1 ;

  localparam signed [7:0] JUMP_VEL_LOCAL =
      (SCR_H / 11'd5 > 0) ? -$signed({1'b0, SCR_H / 11'd5}) : -8'sd2 ;

  localparam signed [7:0] GRAVITY_ACC_LOCAL =
      (SCR_H / 11'd20 > 0) ?  $signed({1'b0, SCR_H / 11'd20}) :  8'sd1 ;

  localparam signed [7:0] VEL_Y_MAX_LOCAL =
      (SCR_H / 11'd6 > 0) ?  $signed({1'b0, SCR_H / 11'd6}) :  8'sd2 ;

  localparam [10:0] ENEMY_STEP_LOCAL =
      (SCR_W / 11'd30 > 0) ? (SCR_W / 11'd30) : 11'd1 ;

  // =========================================================
  // sterowanie
  // =========================================================
  wire key_left   ;
  wire key_right  ;
  wire key_up     ;
  wire key_down   ;

  assign key_left  = EncA_QA ;
  assign key_right = EncA_QB ;
  assign key_up    = EncB_QB ;
  assign key_down  = EncB_QA ;

  // =========================================================
  // level manager <-> game engine
  // =========================================================
  wire        respawn_req        ;
  wire        respawn_ack        ;

  wire        door_hit           ;
  wire [3:0]  door_target_level  ;
  wire [1:0]  door_target_entry  ;

  // =========================================================
  // level manager outputs
  // =========================================================
  wire [3:0]  level_id           ;
  wire [1:0]  entry_id           ;
  wire [10:0] spawn_x            ;
  wire [10:0] spawn_y            ;

  // =========================================================
  // level data outputs
  // =========================================================
  wire [10:0] level_w            ;
  wire [10:0] level_h            ;

  wire [7:0]  plat_count         ;
  wire [MAX_PLATFORMS*11-1:0] plat_x_bus ;
  wire [MAX_PLATFORMS*11-1:0] plat_y_bus ;
  wire [MAX_PLATFORMS*11-1:0] plat_w_bus ;
  wire [MAX_PLATFORMS*11-1:0] plat_h_bus ;

  wire [7:0]  door_count         ;
  wire [MAX_DOORS*11-1:0] door_x_bus ;
  wire [MAX_DOORS*11-1:0] door_y_bus ;
  wire [MAX_DOORS*11-1:0] door_w_bus ;
  wire [MAX_DOORS*11-1:0] door_h_bus ;
  wire [MAX_DOORS*4-1:0]  door_target_level_bus ;
  wire [MAX_DOORS*2-1:0]  door_target_entry_bus ;

  wire [10:0] enemy0_start_x     ;
  wire [10:0] enemy0_start_y     ;

  wire [10:0] spawn_left_x       ;
  wire [10:0] spawn_left_y       ;
  wire [10:0] spawn_right_x      ;
  wire [10:0] spawn_right_y      ;
  wire [10:0] spawn_top_x        ;
  wire [10:0] spawn_top_y        ;
  wire [10:0] spawn_bottom_x     ;
  wire [10:0] spawn_bottom_y     ;

  level_manager
  u_level_manager
  (
      .CLK               ( CLK               ) ,
      .RST               ( RST               ) ,

      .DOOR_HIT          ( door_hit          ) ,
      .DOOR_TARGET_LEVEL ( door_target_level ) ,
      .DOOR_TARGET_ENTRY ( door_target_entry ) ,

      .RESPAWN_ACK       ( respawn_ack       ) ,

      .SPAWN_LEFT_X      ( spawn_left_x      ) ,
      .SPAWN_LEFT_Y      ( spawn_left_y      ) ,
      .SPAWN_RIGHT_X     ( spawn_right_x     ) ,
      .SPAWN_RIGHT_Y     ( spawn_right_y     ) ,
      .SPAWN_TOP_X       ( spawn_top_x       ) ,
      .SPAWN_TOP_Y       ( spawn_top_y       ) ,
      .SPAWN_BOTTOM_X    ( spawn_bottom_x    ) ,
      .SPAWN_BOTTOM_Y    ( spawn_bottom_y    ) ,

      .LEVEL_ID          ( level_id          ) ,
      .ENTRY_ID          ( entry_id          ) ,
      .SPAWN_X           ( spawn_x           ) ,
      .SPAWN_Y           ( spawn_y           ) ,
      .RESPAWN_REQ       ( respawn_req       )
  );

  level_data_mux
  #(
      .MAX_PLATFORMS     ( MAX_PLATFORMS     ) ,
      .MAX_DOORS         ( MAX_DOORS         ) ,
      .PLAYER_H          ( PLAYER_H          )
  )
  u_level_data_mux
  (
      .LEVEL_ID               ( level_id               ) ,

      .LEVEL_W                ( level_w                ) ,
      .LEVEL_H                ( level_h                ) ,

      .PLAT_COUNT             ( plat_count             ) ,
      .PLAT_X_BUS             ( plat_x_bus             ) ,
      .PLAT_Y_BUS             ( plat_y_bus             ) ,
      .PLAT_W_BUS             ( plat_w_bus             ) ,
      .PLAT_H_BUS             ( plat_h_bus             ) ,

      .DOOR_COUNT             ( door_count             ) ,
      .DOOR_X_BUS             ( door_x_bus             ) ,
      .DOOR_Y_BUS             ( door_y_bus             ) ,
      .DOOR_W_BUS             ( door_w_bus             ) ,
      .DOOR_H_BUS             ( door_h_bus             ) ,
      .DOOR_TARGET_LEVEL_BUS  ( door_target_level_bus  ) ,
      .DOOR_TARGET_ENTRY_BUS  ( door_target_entry_bus  ) ,

      .ENEMY0_START_X         ( enemy0_start_x         ) ,
      .ENEMY0_START_Y         ( enemy0_start_y         ) ,

      .SPAWN_LEFT_X           ( spawn_left_x           ) ,
      .SPAWN_LEFT_Y           ( spawn_left_y           ) ,
      .SPAWN_RIGHT_X          ( spawn_right_x          ) ,
      .SPAWN_RIGHT_Y          ( spawn_right_y          ) ,
      .SPAWN_TOP_X            ( spawn_top_x            ) ,
      .SPAWN_TOP_Y            ( spawn_top_y            ) ,
      .SPAWN_BOTTOM_X         ( spawn_bottom_x         ) ,
      .SPAWN_BOTTOM_Y         ( spawn_bottom_y         )
  );

  // =========================================================
  // rozpakowanie platform / drzwi do render_main
  // =========================================================
  wire [10:0] floor_x ;
  wire [10:0] floor_y ;
  wire [10:0] floor_w ;
  wire [10:0] floor_h ;

  wire [10:0] plat0_x ;
  wire [10:0] plat0_y ;
  wire [10:0] plat0_w ;
  wire [10:0] plat0_h ;

  wire [10:0] plat1_x ;
  wire [10:0] plat1_y ;
  wire [10:0] plat1_w ;
  wire [10:0] plat1_h ;

  wire [10:0] door0_x ;
  wire [10:0] door0_y ;
  wire [10:0] door0_w ;
  wire [10:0] door0_h ;

  assign floor_x = plat_x_bus[0*11 +: 11] ;
  assign floor_y = plat_y_bus[0*11 +: 11] ;
  assign floor_w = plat_w_bus[0*11 +: 11] ;
  assign floor_h = plat_h_bus[0*11 +: 11] ;

  assign plat0_x = plat_x_bus[1*11 +: 11] ;
  assign plat0_y = plat_y_bus[1*11 +: 11] ;
  assign plat0_w = plat_w_bus[1*11 +: 11] ;
  assign plat0_h = plat_h_bus[1*11 +: 11] ;

  assign plat1_x = plat_x_bus[2*11 +: 11] ;
  assign plat1_y = plat_y_bus[2*11 +: 11] ;
  assign plat1_w = plat_w_bus[2*11 +: 11] ;
  assign plat1_h = plat_h_bus[2*11 +: 11] ;

  assign door0_x = door_x_bus[0*11 +: 11] ;
  assign door0_y = door_y_bus[0*11 +: 11] ;
  assign door0_w = door_w_bus[0*11 +: 11] ;
  assign door0_h = door_h_bus[0*11 +: 11] ;

  // =========================================================
  // stan gracza / przeciwnika / kamera
  // =========================================================
  wire [10:0] player_x ;
  wire [10:0] player_y ;

  wire [10:0] enemy0_x ;
  wire [10:0] enemy0_y ;
  wire        enemy0_dir_right ;

  wire [10:0] camera_x ;

  game_engine
  #(
      .MAX_PLATFORMS     ( MAX_PLATFORMS     ) ,
      .MAX_DOORS         ( MAX_DOORS         ) ,
      .SCR_W             ( SCR_W             ) ,
      .SCR_H             ( SCR_H             ) ,
      .PLAYER_W          ( PLAYER_W          ) ,
      .PLAYER_H          ( PLAYER_H          ) ,
      .MOVE_STEP         ( MOVE_STEP_LOCAL   ) ,
      .ENEMY_W           ( ENEMY_W           ) ,
      .ENEMY_H           ( ENEMY_H           ) ,
      .ENEMY_STEP        ( ENEMY_STEP_LOCAL  ) ,
      .ENEMY_TICK_DIV    ( ENEMY_TICK_DIV    ) ,
      .TICK_CNT_MAX      ( TICK_CNT_MAX      ) ,
      .JUMP_VEL          ( JUMP_VEL_LOCAL    ) ,
      .GRAVITY_ACC       ( GRAVITY_ACC_LOCAL ) ,
      .VEL_Y_MAX         ( VEL_Y_MAX_LOCAL   )
  )
  u_game_engine
  (
      .CLK               ( CLK                   ) ,
      .RST               ( RST                   ) ,

      .KEY_LEFT          ( key_left              ) ,
      .KEY_RIGHT         ( key_right             ) ,
      .KEY_UP            ( key_up                ) ,
      .KEY_DOWN          ( key_down              ) ,

      .RESPAWN_REQ       ( respawn_req           ) ,
      .SPAWN_X           ( spawn_x               ) ,
      .SPAWN_Y           ( spawn_y               ) ,
      .RESPAWN_ACK       ( respawn_ack           ) ,

      .LEVEL_W           ( level_w               ) ,
      .LEVEL_H           ( level_h               ) ,

      .PLAT_COUNT        ( plat_count            ) ,
      .PLAT_X_BUS        ( plat_x_bus            ) ,
      .PLAT_Y_BUS        ( plat_y_bus            ) ,
      .PLAT_W_BUS        ( plat_w_bus            ) ,
      .PLAT_H_BUS        ( plat_h_bus            ) ,

      .DOOR_COUNT             ( door_count            ) ,
      .DOOR_X_BUS             ( door_x_bus            ) ,
      .DOOR_Y_BUS             ( door_y_bus            ) ,
      .DOOR_W_BUS             ( door_w_bus            ) ,
      .DOOR_H_BUS             ( door_h_bus            ) ,
      .DOOR_TARGET_LEVEL_BUS  ( door_target_level_bus ) ,
      .DOOR_TARGET_ENTRY_BUS  ( door_target_entry_bus ) ,

      .ENEMY0_START_X     ( enemy0_start_x       ) ,
      .ENEMY0_START_Y     ( enemy0_start_y       ) ,

      .PLAYER_X           ( player_x             ) ,
      .PLAYER_Y           ( player_y             ) ,

      .ENEMY0_X           ( enemy0_x             ) ,
      .ENEMY0_Y           ( enemy0_y             ) ,
      .ENEMY0_DIR_RIGHT   ( enemy0_dir_right     ) ,

      .DOOR_HIT           ( door_hit             ) ,
      .DOOR_TARGET_LEVEL  ( door_target_level    ) ,
      .DOOR_TARGET_ENTRY  ( door_target_entry    )
  );

  camera_engine
  #(
      .SCR_W             ( SCR_W                 ) ,
      .PLAYER_W          ( PLAYER_W              )
  )
  u_camera_engine
  (
      .CLK               ( CLK                   ) ,
      .RST               ( RST                   ) ,
      .PLAYER_X          ( player_x              ) ,
      .LEVEL_W           ( level_w               ) ,
      .CAMERA_X          ( camera_x              )
  );

  render_main
  #(
      .SCR_W             ( SCR_W                 ) ,
      .SCR_H             ( SCR_H                 ) ,
      .PLAYER_W          ( PLAYER_W              ) ,
      .PLAYER_H          ( PLAYER_H              ) ,
      .ENEMY_W           ( ENEMY_W               ) ,
      .ENEMY_H           ( ENEMY_H               )
  )
  u_render_main
  (
      .CLK               ( CLK                   ) ,
      .RST               ( RST                   ) ,
      .H_CNT             ( H_CNT                 ) ,
      .V_CNT             ( V_CNT                 ) ,

      .CAMERA_X          ( camera_x              ) ,

      .PLAYER_X          ( player_x              ) ,
      .PLAYER_Y          ( player_y              ) ,

      .ENEMY0_X          ( enemy0_x              ) ,
      .ENEMY0_Y          ( enemy0_y              ) ,

      .FLOOR_X           ( floor_x               ) ,
      .FLOOR_Y           ( floor_y               ) ,
      .FLOOR_W           ( floor_w               ) ,
      .FLOOR_H           ( floor_h               ) ,

      .PLAT0_X           ( plat0_x               ) ,
      .PLAT0_Y           ( plat0_y               ) ,
      .PLAT0_W           ( plat0_w               ) ,
      .PLAT0_H           ( plat0_h               ) ,

      .PLAT1_X           ( plat1_x               ) ,
      .PLAT1_Y           ( plat1_y               ) ,
      .PLAT1_W           ( plat1_w               ) ,
      .PLAT1_H           ( plat1_h               ) ,

      .DOOR0_X           ( door0_x               ) ,
      .DOOR0_Y           ( door0_y               ) ,
      .DOOR0_W           ( door0_w               ) ,
      .DOOR0_H           ( door0_h               ) ,

      .RED               ( RED                   ) ,
      .GREEN             ( GREEN                 ) ,
      .BLUE              ( BLUE                  )
  );

  assign LED[0] = key_left  ;
  assign LED[1] = key_right ;
  assign LED[2] = key_up    ;
  assign LED[3] = door_hit  ;

  endmodule