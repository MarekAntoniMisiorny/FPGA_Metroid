`timescale 1ns / 100ps
`default_nettype none

module tb();

  reg RST;
  initial begin
    RST = 1'b1;
    #10
    RST = 1'b0;
  end

  reg CLK75_0;
  initial CLK75_0 <= 0;
  always #6.6 CLK75_0 <= ~CLK75_0;

  reg EncA_QA;
  reg EncA_QB;
  reg EncB_QA;
  reg EncB_QB;

  wire       VID_HSYNC;
  wire       VID_VSYNC;
  wire       VID_DE;
  wire [7:0] VID_RED;
  wire [7:0] VID_GREEN;
  wire [7:0] VID_BLUE;
  wire       VID_HSYNC_d;
  wire       VID_VSYNC_d;
  wire       VID_DE_d;

  wire [3:0] LED;

  integer key_file;
  integer key_left_tmp;
  integer key_right_tmp;
  integer scan_ok;
integer key_up_tmp;
integer key_down_tmp;
  integer time_file;
  integer file;
  integer frame_cnt;
  integer frame_div;

  integer x, y;

  localparam [10:0] SCR_W = 30;
  localparam [10:0] SCR_H = 20;
  localparam integer FRAME_WRITE_DIV = 2; // zapis co 2 klatki

  wire [10:0] x_hcnt;
  wire [10:0] x_vcnt;
  wire [10:0] x_hcnt_d;
  wire [10:0] x_vcnt_d;

  initial begin
    EncA_QA   = 0;
    EncA_QB   = 0;
    EncB_QA   = 0;
    EncB_QB   = 0;
    frame_cnt = 0;
    frame_div = 0;
  end

  vga_sync_gen pong_vga_sync_gen (
    .CLK (CLK75_0),
    .RST (RST),

    .GEN_ACTIVE    (VID_DE),
    .GEN_RGB       (),
    .GEN_HSYNC     (),
    .GEN_HSYNCP    (VID_HSYNC),
    .GEN_HCNT      (x_hcnt),
    .GEN_VSYNC     (),
    .GEN_VSYNCP    (VID_VSYNC),
    .GEN_VCNT      (x_vcnt),

    .H_ACTIVE      (SCR_W),
    .H_FRONT_PORCH (11'd3),
    .H_BACK_PORCH  (11'd1),
    .H_SYNC        (11'd1),
    .H_SYNC_POL    (1'd0),

    .V_ACTIVE      (SCR_H),
    .V_FRONT_PORCH (11'd1),
    .V_BACK_PORCH  (11'd1),
    .V_SYNC        (11'd1),
    .V_SYNC_POL    (1'd0)
  );

  parameter CTRL_DELAY = 5;
  delay #(.D(CTRL_DELAY))        del1 (.CLK(CLK75_0), .I(VID_DE),    .O(VID_DE_d));
  delay #(.D(CTRL_DELAY))        del2 (.CLK(CLK75_0), .I(VID_HSYNC), .O(VID_HSYNC_d));
  delay #(.D(CTRL_DELAY))        del3 (.CLK(CLK75_0), .I(VID_VSYNC), .O(VID_VSYNC_d));
  delay #(.D(CTRL_DELAY),.W(11)) del4 (.CLK(CLK75_0), .I(x_hcnt),    .O(x_hcnt_d));
  delay #(.D(CTRL_DELAY),.W(11)) del5 (.CLK(CLK75_0), .I(x_vcnt),    .O(x_vcnt_d));

  pong_main #(
    .SCR_W (SCR_W),
    .SCR_H (SCR_H)
  ) my_pong_inst (
    .CLK    (CLK75_0),
    .RST    (RST),
    .H_CNT  (x_hcnt),
    .V_CNT  (x_vcnt),
    .RED    (VID_RED),
    .GREEN  (VID_GREEN),
    .BLUE   (VID_BLUE),
    .EncA_QA(EncA_QA),
    .EncA_QB(EncA_QB),
    .EncB_QA(EncB_QA),
    .EncB_QB(EncB_QB),
    .LED    (LED)
  );

  reg [2:0] VIDMEM [0:SCR_W*SCR_H-1];
  always @(posedge CLK75_0)
    if (VID_DE_d)
      VIDMEM[x_hcnt_d + x_vcnt_d*SCR_W] <= { |VID_RED, |VID_GREEN, |VID_BLUE };

  localparam pixel = 15;

  initial begin
    file = $fopen("size.txt", "w+");
    $fwrite(file, "%d\n%d\n%d\n", SCR_W, SCR_H, pixel);
    $fclose(file);
  end

  reg vsync_d;
  always @(posedge CLK75_0 or posedge RST) begin
    if (RST) begin
      vsync_d   <= 1'b0;
      EncA_QA   <= 1'b0;
      EncA_QB   <= 1'b0;
      EncB_QA   <= 1'b0;
      EncB_QB   <= 1'b0;
      frame_cnt <= 0;
      frame_div <= 0;
    end
    else begin
      vsync_d <= VID_VSYNC_d;

      if (vsync_d == 1'b1 && VID_VSYNC_d == 1'b0) begin
        frame_cnt <= frame_cnt + 1;
        frame_div <= frame_div + 1;

        // --- odczyt klawiszy raz na klatkê
       key_file = $fopen("keys.txt", "r");
		if (key_file != 0) begin
		  scan_ok = $fscanf(key_file, "%d %d %d %d\n",
		                    key_left_tmp, key_right_tmp, key_up_tmp, key_down_tmp);
		  $fclose(key_file);
		
		  if (scan_ok == 4) begin
		    EncA_QA <= key_left_tmp[0];
		    EncA_QB <= key_right_tmp[0];
		    EncB_QB <= key_up_tmp[0];
		    EncB_QA <= key_down_tmp[0];
		  end else begin
		    EncA_QA <= 1'b0;
		    EncA_QB <= 1'b0;
		    EncB_QA <= 1'b0;
		    EncB_QB <= 1'b0;
		  end
		end else begin
		  EncA_QA <= 1'b0;
		  EncA_QB <= 1'b0;
		  EncB_QA <= 1'b0;
		  EncB_QB <= 1'b0;
		end
        // --- zapis obrazu co FRAME_WRITE_DIV klatek
        if (frame_div >= FRAME_WRITE_DIV-1) begin
          frame_div <= 0;

          file = $fopen("dane.txt", "w+");
          for (y = 0; y < SCR_H; y = y + 1) begin
            for (x = 0; x < SCR_W; x = x + 1) begin
              $fwrite(file, "%0d", VIDMEM[y*SCR_W + x]);
            end
            $fwrite(file, "\n");
          end
          $fclose(file);

          time_file = $fopen("sim_time.txt", "w+");
          $fwrite(time_file, "%0d\n", $time);
          $fclose(time_file);
        end
      end
    end
  end

endmodule