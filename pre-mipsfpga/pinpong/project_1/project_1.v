module ps2(input PS2_DAT_in,
			  input PS2_CLK_in,
			  input clock,
			  //output reg [7:0] led_out,
			  output [7:0] led_out,			  
			  output reg down,
			  output reg up);



// ------------------
/*
module ps2_keyboard(	
					input	iCLK_50,
					inout   ps2_dat,
					input   ps2_clk,
					output  reg[7:0]scandata
					);*/

wire iCLK_50;
wire ps2_dat;
wire ps2_clk;
reg[7:0]scandata;

assign iCLK_50      = clock;
assign ps2_dat      = PS2_DAT_in;
assign ps2_clk      = PS2_CLK_in; 
assign led_out[7:0] = scandata[7:0];

///////KeyBoard Scan-Code trigger//////
reg keyready;
reg [2:0]kr;
always @(negedge ps2_clk) keyready <= (revcnt[3:0]==10);
always @(posedge clock) begin
 kr <= {kr,keyready};
 if (kr[1]&&~kr[2]) begin
  scandata <= keycode_o;
  if (keycode_o ==8'hE4) begin
   up   <= 0;
   down <= 1;
  end 
  else if (keycode_o == 8'hEA) begin
   up   <= 1;
   down <= 0;
  end 
  else if (keycode_o != 8'hF0) begin
   up   <= 0;
   down <= 0;
  end
 end
end 

reg       ps2_clk_in,ps2_clk_syn1,ps2_dat_in,ps2_dat_syn1;
wire      clk;

//clk division, derive a 97.65625KHz clock from the 50MHz source;
reg [8:0] clk_div;
always@(posedge iCLK_50) clk_div <= clk_div+1;
assign clk = clk_div[8];

//multi-clock region simple synchronization
always@(posedge clk) begin
	ps2_clk_syn1 <= ps2_clk;
	ps2_clk_in   <= ps2_clk_syn1;
	ps2_dat_syn1 <= ps2_dat;
	ps2_dat_in   <= ps2_dat_syn1;
end
reg [7:0]	keycode_o;
reg	[7:0]	revcnt;
	
always @( posedge ps2_clk_in) begin
	if (revcnt >=10) revcnt<=0;
	else             revcnt<=revcnt+1;
end
	
always @(posedge ps2_clk_in) begin
	case (revcnt[3:0])
		1:keycode_o[0]<=ps2_dat_in;
		2:keycode_o[1]<=ps2_dat_in;
		3:keycode_o[2]<=ps2_dat_in;
		4:keycode_o[3]<=ps2_dat_in;
		5:keycode_o[4]<=ps2_dat_in;
		6:keycode_o[5]<=ps2_dat_in;
		7:keycode_o[6]<=ps2_dat_in;
		8:keycode_o[7]<=ps2_dat_in;
	endcase
end
endmodule