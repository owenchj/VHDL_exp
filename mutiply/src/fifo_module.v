module fifo_module
  (

   input 	 CLK,

   input 	 RSTn,


   input 	 Write_Req,

   input [15:0]  FIFO_Write_Data,


   input 	 Read_Req,

   output [15:0] FIFO_Read_Data,

   output [2:0]  Left_Sig
   );
   
   /************************************/
   parameter DEEP = 3'd4;
   /************************************/
   reg [15:0] 	 rShift [DEEP:0];
   reg [2:0] 	 Count;
   reg [15:0] 	 Data;
   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  rShift[0] <= 15'd0; rShift[1] <= 15'd0; rShift[2] <= 15'd0;
	  rShift[3] <= 15'd0; rShift[4] <= 15'd0;
	  Count <= 3'd0;
	  Data <= 15'd0;
       end
     else if( Read_Req && Write_Req && Count < DEEP && Count > 0 )
       begin
	  rShift[1] <= FIFO_Write_Data;
	  rShift[2] <= rShift[1];
	  rShift[3] <= rShift[2];
	  rShift[4] <= rShift[3];
	  Data <= rShift[ Count ];
       end
     else if( Write_Req && Count < DEEP )
       begin
	  rShift[1] <= FIFO_Write_Data;
	  rShift[2] <= rShift[1];
	  rShift[3] <= rShift[2];
	  rShift[4] <= rShift[3];
	  Count <= Count + 1'b1;
       end
     else if( Read_Req && Count > 0 )
       begin
	  Data <= rShift[Count];

	  Count <= Count - 1'b1;

       end



   /************************************/


   assign FIFO_Read_Data = Data;

   assign Left_Sig = DEEP - Count;


   /************************************/

endmodule
