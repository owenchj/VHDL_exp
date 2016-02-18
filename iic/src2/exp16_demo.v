module exp16_demo
  (
   input 	CLK,
   input 	RSTn,
   output [3:0] LED,
   output 	SCL,
   inout 	SDA
   );


   /***************************/

   wire [7:0] 	RdData;
   wire 	Done_Sig;

   iic_func_module U1
     (
      .CLK( CLK ),
      .RSTn( RSTn ),
      .Start_Sig( isStart ),
      .Addr_Sig( rAddr ),
      .WrData( rData ),
      .RdData( RdData ),
      .Done_Sig( Done_Sig ),
      .SCL( SCL ),
      .SDA( SDA )

      );


   /***************************/

   reg [3:0] 	i;
   reg [7:0] 	rAddr;
   reg [7:0] 	rData;
   reg [1:0] 	isStart;
   reg [3:0] 	rLED;



   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )

       begin
	  i <= 4'd0;
	  rAddr <= 8'd0;
	  rData <= 8'd0;
	  isStart <= 2'b00;
	  rLED <= 4'd10;



       end
     else
       case( i )

	 0:
	   if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end
	   else begin isStart <= 2'b01; rAddr <= 8'd0; rData <= 8'h0c; end

	 1:
	   if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end
	   else begin isStart <= 2'b10; rAddr <= 8'd0; end

	 2:
	   begin rLED <= RdData[3:0]; end


       endcase


   /***************************/


   assign LED = rLED;


   /***************************/

endmodule
