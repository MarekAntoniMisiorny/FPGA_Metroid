module pong_main
#(
  parameter SCR_W = 1280,
  parameter SCR_H = 720
)
(
	input wire        CLK, // CLK 75MHz
	input wire        RST, // Active high reset
  
	input wire [10:0] H_CNT, // horizontal pixel pointer
	input wire [10:0] V_CNT, // vertical   pixel pointer
	
	input wire        EncA_QA, 
	input wire        EncA_QB,
	input wire        EncB_QA,
	input wire        EncB_QB,
	
	output wire [7:0] RED,
	output wire [7:0] GREEN,
	output wire [7:0] BLUE,
	
	output wire [3:0] LED
  );

  // Constant output 
  assign RED   = 8'hFD;
  assign GREEN = 8'h67;
  assign BLUE  = 8'hDF;
  
  //-----------------------------------------
  // assign LED to counter bits to indicate FPGA is working
  reg [31:0] heartbeat;
  always@(posedge CLK or posedge RST)
  if(RST) heartbeat <=             32'd0;
  else    heartbeat <= heartbeat + 32'd1;
  
  assign LED[3:0] = heartbeat[26:23];
  //-----------------------------------------
endmodule