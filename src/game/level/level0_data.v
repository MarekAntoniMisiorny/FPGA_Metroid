`timescale 1ns / 100ps
`default_nettype none

  module level0_data
  #(
      parameter integer MAX_PLATFORMS = 8      ,
      parameter integer MAX_DOORS     = 4      ,
      parameter integer MAX_ENEMIES   = 8      ,
      parameter [10:0]  PLAYER_H      = 11'd4  ,
      parameter [10:0]  ENEMY_W       = 11'd2  ,
      parameter [10:0]  ENEMY_H       = 11'd3
  )
  (
      output wire [10:0] LEVEL_W      ,
      output wire [10:0] LEVEL_H      ,

      output wire [7:0]  PLAT_COUNT   ,
      output wire [MAX_PLATFORMS*11-1:0] PLAT_X_BUS ,
      output wire [MAX_PLATFORMS*11-1:0] PLAT_Y_BUS ,
      output wire [MAX_PLATFORMS*11-1:0] PLAT_W_BUS ,
      output wire [MAX_PLATFORMS*11-1:0] PLAT_H_BUS ,

      output wire [7:0]  DOOR_COUNT   ,
      output wire [MAX_DOORS*11-1:0] DOOR_X_BUS ,
      output wire [MAX_DOORS*11-1:0] DOOR_Y_BUS ,
      output wire [MAX_DOORS*11-1:0] DOOR_W_BUS ,
      output wire [MAX_DOORS*11-1:0] DOOR_H_BUS ,
      output wire [MAX_DOORS*4-1:0]  DOOR_TARGET_LEVEL_BUS ,
      output wire [MAX_DOORS*2-1:0]  DOOR_TARGET_ENTRY_BUS ,

      output wire [7:0]  ENEMY_COUNT         ,
      output wire [MAX_ENEMIES*4-1:0]  ENEMY_TYPE_BUS      ,
      output wire [MAX_ENEMIES*11-1:0] ENEMY_START_X_BUS   ,
      output wire [MAX_ENEMIES*11-1:0] ENEMY_START_Y_BUS   ,
      output wire [MAX_ENEMIES*2-1:0]  ENEMY_START_DIR_BUS ,
      output wire [MAX_ENEMIES*11-1:0] ENEMY_ANCHOR_X_BUS  ,
      output wire [MAX_ENEMIES*11-1:0] ENEMY_ANCHOR_Y_BUS  ,
      output wire [MAX_ENEMIES*11-1:0] ENEMY_ANCHOR_W_BUS  ,
      output wire [MAX_ENEMIES*11-1:0] ENEMY_ANCHOR_H_BUS  ,

      output wire [10:0] SPAWN_LEFT_X   ,
      output wire [10:0] SPAWN_LEFT_Y   ,
      output wire [10:0] SPAWN_RIGHT_X  ,
      output wire [10:0] SPAWN_RIGHT_Y  ,
      output wire [10:0] SPAWN_TOP_X    ,
      output wire [10:0] SPAWN_TOP_Y    ,
      output wire [10:0] SPAWN_BOTTOM_X ,
      output wire [10:0] SPAWN_BOTTOM_Y
  );

  localparam [3:0] TYPE_FLOOR_BOUNCE  = 4'd1 ;
  localparam [3:0] TYPE_PLATFORM_LOOP = 4'd2 ;

  localparam [10:0] LEVEL_W_LOCAL = 11'd60 ;
  localparam [10:0] LEVEL_H_LOCAL = 11'd20 ;

  localparam [10:0] FLOOR_X = 11'd0  ;
  localparam [10:0] FLOOR_Y = 11'd17 ;
  localparam [10:0] FLOOR_W = 11'd60 ;
  localparam [10:0] FLOOR_H = 11'd3  ;

  localparam [10:0] P0_X    = 11'd10 ;
  localparam [10:0] P0_Y    = 11'd10 ;
  localparam [10:0] P0_W    = 11'd7  ;
  localparam [10:0] P0_H    = 11'd2  ;

  localparam [10:0] P1_X    = 11'd42 ;
  localparam [10:0] P1_Y    = 11'd6  ;
  localparam [10:0] P1_W    = 11'd6  ;
  localparam [10:0] P1_H    = 11'd2  ;

  localparam [10:0] D0_X    = 11'd56 ;
  localparam [10:0] D0_Y    = 11'd14 ;
  localparam [10:0] D0_W    = 11'd2  ;
  localparam [10:0] D0_H    = 11'd3  ;

  localparam [10:0] E0_X    = 11'd22 ;
  localparam [10:0] E0_Y    = FLOOR_Y - ENEMY_H ;

  localparam [10:0] E1_X    = P0_X ;
  localparam [10:0] E1_Y    = P0_Y - ENEMY_H ;

  assign LEVEL_W = LEVEL_W_LOCAL ;
  assign LEVEL_H = LEVEL_H_LOCAL ;

  assign PLAT_COUNT = 8'd3 ;

  assign PLAT_X_BUS = {
      {(MAX_PLATFORMS-3)*11{1'b0}} ,
      P1_X ,
      P0_X ,
      FLOOR_X
  };

  assign PLAT_Y_BUS = {
      {(MAX_PLATFORMS-3)*11{1'b0}} ,
      P1_Y ,
      P0_Y ,
      FLOOR_Y
  };

  assign PLAT_W_BUS = {
      {(MAX_PLATFORMS-3)*11{1'b0}} ,
      P1_W ,
      P0_W ,
      FLOOR_W
  };

  assign PLAT_H_BUS = {
      {(MAX_PLATFORMS-3)*11{1'b0}} ,
      P1_H ,
      P0_H ,
      FLOOR_H
  };

  assign DOOR_COUNT = 8'd1 ;

  assign DOOR_X_BUS = {
      {(MAX_DOORS-1)*11{1'b0}} ,
      D0_X
  };

  assign DOOR_Y_BUS = {
      {(MAX_DOORS-1)*11{1'b0}} ,
      D0_Y
  };

  assign DOOR_W_BUS = {
      {(MAX_DOORS-1)*11{1'b0}} ,
      D0_W
  };

  assign DOOR_H_BUS = {
      {(MAX_DOORS-1)*11{1'b0}} ,
      D0_H
  };

  assign DOOR_TARGET_LEVEL_BUS = {
      {(MAX_DOORS-1)*4{1'b0}} ,
      4'd1
  };

  assign DOOR_TARGET_ENTRY_BUS = {
      {(MAX_DOORS-1)*2{1'b0}} ,
      2'd0
  };

  assign ENEMY_COUNT = 8'd2 ;

  assign ENEMY_TYPE_BUS = {
      {(MAX_ENEMIES-2)*4{1'b0}} ,
      TYPE_PLATFORM_LOOP ,
      TYPE_FLOOR_BOUNCE
  };

  assign ENEMY_START_X_BUS = {
      {(MAX_ENEMIES-2)*11{1'b0}} ,
      E1_X ,
      E0_X
  };

  assign ENEMY_START_Y_BUS = {
      {(MAX_ENEMIES-2)*11{1'b0}} ,
      E1_Y ,
      E0_Y
  };

  assign ENEMY_START_DIR_BUS = {
      {(MAX_ENEMIES-2)*2{1'b0}} ,
      2'd0 ,
      2'd0
  };

  assign ENEMY_ANCHOR_X_BUS = {
      {(MAX_ENEMIES-2)*11{1'b0}} ,
      P0_X ,
      11'd0
  };

  assign ENEMY_ANCHOR_Y_BUS = {
      {(MAX_ENEMIES-2)*11{1'b0}} ,
      P0_Y ,
      11'd0
  };

  assign ENEMY_ANCHOR_W_BUS = {
      {(MAX_ENEMIES-2)*11{1'b0}} ,
      P0_W ,
      11'd0
  };

  assign ENEMY_ANCHOR_H_BUS = {
      {(MAX_ENEMIES-2)*11{1'b0}} ,
      P0_H ,
      11'd0
  };

  assign SPAWN_LEFT_X   = 11'd2 ;
  assign SPAWN_LEFT_Y   = FLOOR_Y - PLAYER_H ;

  assign SPAWN_RIGHT_X  = 11'd54 ;
  assign SPAWN_RIGHT_Y  = FLOOR_Y - PLAYER_H ;

  assign SPAWN_TOP_X    = 11'd30 ;
  assign SPAWN_TOP_Y    = 11'd2 ;

  assign SPAWN_BOTTOM_X = 11'd30 ;
  assign SPAWN_BOTTOM_Y = FLOOR_Y - PLAYER_H ;

  endmodule