`timescale 1ns / 100ps
`default_nettype none

  module enemy_platform_loop_next
  #(
      parameter [10:0] ENEMY_W    = 11'd2 ,
      parameter [10:0] ENEMY_H    = 11'd3 ,
      parameter [10:0] ENEMY_STEP = 11'd1
  )
  (
      input  wire [10:0] CUR_X     ,
      input  wire [10:0] CUR_Y     ,
      input  wire [1:0]  CUR_DIR   ,

      input  wire [10:0] ANCHOR_X  ,
      input  wire [10:0] ANCHOR_Y  ,
      input  wire [10:0] ANCHOR_W  ,
      input  wire [10:0] ANCHOR_H  ,

      output reg  [10:0] NEXT_X    ,
      output reg  [10:0] NEXT_Y    ,
      output reg  [1:0]  NEXT_DIR
  );

  localparam [1:0] DIR_TOP    = 2'd0 ;
  localparam [1:0] DIR_RSIDE  = 2'd1 ;
  localparam [1:0] DIR_BOTTOM = 2'd2 ;
  localparam [1:0] DIR_LSIDE  = 2'd3 ;

  // =========================================================
  // prostok¹t obwodu po którym porusza siê TOP-LEFT przeciwnika
  // =========================================================
  reg [10:0] out_x0 ;
  reg [10:0] out_y0 ;
  reg [10:0] out_x1 ;
  reg [10:0] out_y1 ;

  always @(*) begin
      out_x0 = ANCHOR_X - ENEMY_W ;
      out_y0 = ANCHOR_Y - ENEMY_H ;
      out_x1 = ANCHOR_X + ANCHOR_W ;
      out_y1 = ANCHOR_Y + ANCHOR_H ;

      NEXT_X   = CUR_X   ;
      NEXT_Y   = CUR_Y   ;
      NEXT_DIR = CUR_DIR ;

      case (CUR_DIR)

          // =================================================
          // góra: lewo -> prawo
          // y = out_y0
          // =================================================
          DIR_TOP : begin
              if (CUR_X + ENEMY_STEP >= out_x1) begin
                  NEXT_X   = out_x1    ;
                  NEXT_Y   = out_y0    ;
                  NEXT_DIR = DIR_RSIDE ;
              end
              else begin
                  NEXT_X   = CUR_X + ENEMY_STEP ;
                  NEXT_Y   = out_y0             ;
                  NEXT_DIR = DIR_TOP            ;
              end
          end

          // =================================================
          // prawa œciana: góra -> dó³
          // x = out_x1
          // =================================================
          DIR_RSIDE : begin
              if (CUR_Y + ENEMY_STEP >= out_y1) begin
                  NEXT_X   = out_x1     ;
                  NEXT_Y   = out_y1     ;
                  NEXT_DIR = DIR_BOTTOM ;
              end
              else begin
                  NEXT_X   = out_x1             ;
                  NEXT_Y   = CUR_Y + ENEMY_STEP ;
                  NEXT_DIR = DIR_RSIDE          ;
              end
          end

          // =================================================
          // dó³: prawo -> lewo
          // y = out_y1
          // =================================================
          DIR_BOTTOM : begin
              if (CUR_X <= out_x0 + ENEMY_STEP) begin
                  NEXT_X   = out_x0    ;
                  NEXT_Y   = out_y1    ;
                  NEXT_DIR = DIR_LSIDE ;
              end
              else begin
                  NEXT_X   = CUR_X - ENEMY_STEP ;
                  NEXT_Y   = out_y1             ;
                  NEXT_DIR = DIR_BOTTOM         ;
              end
          end

          // =================================================
          // lewa œciana: dó³ -> góra
          // x = out_x0
          // =================================================
          default : begin
              if (CUR_Y <= out_y0 + ENEMY_STEP) begin
                  NEXT_X   = out_x0   ;
                  NEXT_Y   = out_y0   ;
                  NEXT_DIR = DIR_TOP  ;
              end
              else begin
                  NEXT_X   = out_x0             ;
                  NEXT_Y   = CUR_Y - ENEMY_STEP ;
                  NEXT_DIR = DIR_LSIDE          ;
              end
          end
      endcase
  end

  endmodule