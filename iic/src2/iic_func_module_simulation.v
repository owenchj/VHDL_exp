`timescale 1 ns/ 1 ps
module iic_func_module_simulation();

   reg CLK;
   reg RSTn;

   reg [1:0] Start_Sig;
   reg [7:0] Addr_Sig;
   reg [7:0] WrData;

   wire      Done_Sig;
   wire [7:0] RdData;
   wire       SCL;

   /*************************/


   // io
   reg 	      treg_SDA;
   wire       SDA;
   assign SDA = treg_SDA;


   /*************************/

   wire [4:0] SQ_i;


   /************************/

   iic_func_module U1
     (
      .CLK(CLK),
      .RSTn(RSTn),
      .Start_Sig(Start_Sig),
      .Addr_Sig(Addr_Sig),
      .WrData(WrData),
      .Done_Sig(Done_Sig),
      .RdData(RdData),
      .SCL(SCL),
      .SDA(SDA),
      /******************/
      .SQ_i( SQ_i )

      );


   /***************************/
   initial
     begin

	RSTn = 0; #10 RSTn = 1;



	CLK = 1; forever #25 CLK = ~CLK;
     end
   /******************************/


   reg [3:0]i;



   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )

       begin

	  i <= 4'd0;
	  Start_Sig <= 2'd0;
	  Addr_Sig <= 8'd0;
	  WrData <= 8'd0;
       end
     else
       case( i )

	 0:
	   if( Done_Sig ) begin Start_Sig <= 2'd0; i <= i + 1'b1; end
	   else begin Start_Sig <= 2'b01; Addr_Sig <= 8'b10101010; WrData <= 8'b10101010; end

	 1:
	   if( Done_Sig ) begin Start_Sig <= 2'd0; i <= i + 1'b1; end
	   else begin Start_Sig <= 2'b10; Addr_Sig <= 8'b10101010; end

	 2:
	   i <= i;


       endcase


   /**************************************/


   always @ ( posedge CLK or negedge RSTn )

     if( !RSTn )

       treg_SDA <= 1'b1;
     else if( Start_Sig[0] )
       case( SQ_i )

	 15: treg_SDA = 1'b0;
	 default treg_SDA = 1'b1;
       endcase

     else if( Start_Sig[1] )

       case( SQ_i )
	 17: treg_SDA = 1'b0;

	 19,20,21,22,23,24,25,26:
	   treg_SDA = WrData[ 26-SQ_i ];


	 default treg_SDA = 1'b1;
       endcase


   /**************************************/

endmodule
