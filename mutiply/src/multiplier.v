module multiplier
  (

   input 	 CLK,

   input 	 RSTn,


   input 	 Write_Req,

   input [15:0]  FIFO_Write_Data,

   output [2:0]  Left_Sig,


   output [15:0] Product
   );


   /**************************/


   reg 		 isRead;


   wire [2:0] 	 U1_Left_Sig;

   wire [15:0] 	 U1_Read_Data;


   fifo_module U1

     (

      .CLK( CLK ),

      .RSTn( RSTn ),

      .Write_Req( Write_Req ),

      .FIFO_Write_Data( FIFO_Write_Data ),

      .Read_Req( isRead ),
      .FIFO_Read_Data( U1_Read_Data ),
      .Left_Sig( U1_Left_Sig )
      );
   /**************************/
   reg 		 isStart;
   wire 	 U2_Done_Sig;
   wire [15:0] 	 U2_Product;
   modified_booth_multiplier_module_2 U2
     (
      .CLK( CLK ),
      .RSTn( RSTn ),
      .Start_Sig( isStart ),
      .A( U1_Read_Data[15:8] ),
      .B( U1_Read_Data[7:0] ),
      .Done_Sig( U2_Done_Sig ),
      .Product( U2_Product )
      );
   /**************************/
   reg 		 i;
   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  isRead <= 1'b0;
	  isStart <= 1'b0;
	  i <= 1'b0;
       end
     else
       case( i )
	 0:
	   if( U1_Left_Sig <= 3 ) begin isRead <= 1'b1; i <= i + 1'b1; end
	 1:
	   if( U2_Done_Sig ) begin isStart <= 1'b0; i <= i - 1'b1; end
	   else begin isRead <= 1'b0; isStart <= 1'b1; end
       endcase


   /**************************/


   assign Left_Sig = U1_Left_Sig;


   assign Product = U2_Product;


   /**************************/

endmodule
