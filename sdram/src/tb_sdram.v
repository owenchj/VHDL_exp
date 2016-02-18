`timescale 1 ns/ 1 ns
module tb_sdram();

   reg CLK;
   reg RSTn;

   wire sdram_clk;
   wire sdram_cmd;
   wire sdram_ba;
   wire sdram_data;
   wire sdram_udqm;
   wire sdram_ldqm;
   wire led;
   
   /*******************/

   sdram_demo U1
     (
      .CLK(CLK),
      .RSTn(RSTn),
      .SDRAM_CLK(sdram_clk),
      .SDRAM_CMD(sdram_cmd),
      .SDRAM_BA(sdram_ba),
      .SDRAM_DATA(sdram_data),
      .SDRAM_UDQM(sdram_udqm),
      .SDRAM_LDQM(sdram_ldqm),
      .LED(led)
      );

   
   /*******************/

   initial
     begin
	CLK = 0;  
	RSTn = 0; #1000; RSTn = 1;
     end
   /*******************/
   always 
     begin
	#10 CLK = ~CLK;
     end

endmodule

