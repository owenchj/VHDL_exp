`timescale 1 ns/ 1 ns
module tb_multiplier();

   reg CLK;
   reg RSTn;

   reg Write_Req;
   reg [15:0] FIFO_Write_Data;
   wire [2:0] Left_Sig;


   wire [15:0] Product;


   /*****************************/

   multiplier U1
     (
      .CLK(CLK),
      .RSTn(RSTn),
      .Write_Req(Write_Req),
      .FIFO_Write_Data(FIFO_Write_Data),

      .Left_Sig(Left_Sig),


      .Product(Product)
      );


   /*****************************/

   initial
     begin
	RSTn = 0; #10; RSTn = 1;
	CLK = 0; forever #10 CLK = ~CLK;

     end


   /*****************************/


   reg [3:0]i;



   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )

       begin

	  Write_Req <= 1'b0;
	  FIFO_Write_Data <= 16'd0;
	  i <= 4'd0;



       end
     else
       case( i )

	 0:
	   if( Left_Sig >= 1 ) begin Write_Req <= 1'b1; FIFO_Write_Data <= { 8'd12 , 8'd9 }; i <= i + 1'b1; end
	   else Write_Req <= 1'b0;

	 1:
	   if( Left_Sig >= 1 ) begin Write_Req <= 1'b1; FIFO_Write_Data <= { 8'd33 , 8'd10 }; i <= i + 1'b1; end
	   else Write_Req <= 1'b0;

	 2:
	   if( Left_Sig >= 1 ) begin Write_Req <= 1'b1; FIFO_Write_Data <= { 8'd40 , 8'd5 }; i <= i + 1'b1; end
	   else Write_Req <= 1'b0;

	 3:
	   if( Left_Sig >= 1 ) begin Write_Req <= 1'b1; FIFO_Write_Data <= { 8'd127 , 8'd127 }; i <= i + 1'b1; end
	   else Write_Req <= 1'b0;
	 4:
	   if( Left_Sig >= 1 ) begin Write_Req <= 1'b1; FIFO_Write_Data <= { 8'd37 , 8'd21 }; i <= i + 1'b1; end
	   else Write_Req <= 1'b0;

	 5,6,7,8:
	   begin Write_Req <= 1'b0; i <= i + 1'b1; end

	 9:
	   if( Left_Sig >= 1 ) begin Write_Req <= 1'b1; FIFO_Write_Data <= { 8'd9 , 8'd8 }; i <= i + 1'b1; end
	   else Write_Req <= 1'b0;

	 10:
	   begin Write_Req <= 1'b0; i <= 4'd10; end


       endcase


   /*****************************/


endmodule
