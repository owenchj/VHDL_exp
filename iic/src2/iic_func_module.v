module iic_func_module
  (
   input 	CLK,
   input 	RSTn,

   input [1:0] 	Start_Sig,
   input [7:0] 	Addr_Sig,
   input [7:0] 	WrData,
   output [7:0] RdData,
   output 	Done_Sig,

   output 	SCL,
   inout 	SDA,

   /***************/
   output [4:0] SQ_i

   );


   /*************************/


   parameter FREQ = 9'd200;


   /*************************/

   reg [4:0] 	i;
   reg [4:0] 	Go;
   reg [8:0] 	C1;

   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  i <= 5'd0;
	  Go <= 5'd0;
	  C1 <= 9'd0;
	  rData <= 8'd0;
	  rSCL <= 1'b1;
	  rSDA <= 1'b1;
	  isAck <= 1'b1;
	  isDone <= 1'b0;
	  isOut <= 1'b1;
       end
     else if( Start_Sig[0] )
       case( i )

	 0: // Start
	   begin

	      isOut = 1;

	      rSCL <= 1'b1;

	      if( C1 == 0 ) rSDA <= 1'b1;
	      else if( C1 == 100 ) rSDA <= 1'b0;

	      if( C1 == FREQ -1) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 1: // Write Device Addr
	   begin rData <= {4'b1010, 3'b000, 1'b0}; i <= 5'd7; Go <= i + 1'b1; end

	 2: // Wirte Word Addr
	   begin rData <= Addr_Sig; i <= 5'd7; Go <= i + 1'b1; end

	 3: // Write Data
	   begin rData <= WrData; i <= 5'd7; Go <= i + 1'b1; end


	 /*************************/

	 4: // Stop
	   begin

	      isOut = 1'b1;

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 50 ) rSCL <= 1'b1;

	      if( C1 == 0 ) rSDA <= 1'b0;
	      else if( C1 == 150 ) rSDA <= 1'b1;

	      if( C1 == 50 + FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 5:
	   begin isDone <= 1'b1; i <= i + 1'b1; end

	 6:
	   begin isDone <= 1'b0; i <= 5'd0; end


	 /*******************************/ //function

	 7,8,9,10,11,12,13,14:
	   begin
	      isOut = 1'b1;
	      rSDA <= rData[14-i];

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 100 ) rSCL <= 1'b1;

	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 15: // waiting for acknowledge
	   begin
	      isOut = 1'b0;
	      if( C1 == 150 ) isAck <= SDA;

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 100 ) rSCL <= 1'b1;

	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 16:
	   if( isAck != 0 ) i <= 5'd0;
	   else i <= Go;


	 /*******************************/ // end function


       endcase // case ( i )

     else if( Start_Sig[1] )
       case( i )

	 0: // Start
	   begin

	      isOut = 1;

	      rSCL <= 1'b1;

	      if( C1 == 0 ) rSDA <= 1'b1;
	      else if( C1 == 100 ) rSDA <= 1'b0;

	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 1: // Write Device Addr
	   begin rData <= {4'b1010, 3'b000, 1'b0}; i <= 5'd9; Go <= i + 1'b1; end

	 2: // Wirte Word Addr
	   begin rData <= Addr_Sig; i <= 5'd9; Go <= i + 1'b1; end

	 3: // Start again
	   begin

	      isOut = 1'b1;

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 50 ) rSCL <= 1'b1;
	      else if( C1 == 250 ) rSCL <= 1'b0;

	      if( C1 == 0 ) rSDA <= 1'b0;
	      else if( C1 == 50 ) rSDA <= 1'b1;
	      else if( C1 == 150 ) rSDA <= 1'b0;

	      if( C1 == 300 -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 4: // Write Device Addr ( Read )
	   begin rData <= {4'b1010, 3'b000, 1'b1}; i <= 5'd9; Go <= i + 1'b1; end

	 5: // Read Data
	   begin rData <= 8'd0; i <= 5'd19; Go <= i + 1'b1; end


	 6: // Stop
	   begin

	      isOut = 1'b1;


	      if( C1 == 0 ) rSCL <= 1'b0;

	      else if( C1 == 50 ) rSCL <= 1'b1;

	      if( C1 == 0 ) rSDA <= 1'b0;
	      else if( C1 == 150 ) rSDA <= 1'b1;

	      if( C1 == 50 + FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 7:
	   begin isDone <= 1'b1; i <= i + 1'b1; end

	 8:
	   begin isDone <= 1'b0; i <= 5'd0; end


	 /*******************************/ //function

	 9,10,11,12,13,14,15,16:
	   begin

	      isOut = 1'b1;


	      rSDA <= rData[16-i];

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 100 ) rSCL <= 1'b1;

	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 17: // waiting for acknowledge
	   begin

	      isOut = 1'b0;


	      if( C1 == 150 ) isAck <= SDA;

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 100 ) rSCL <= 1'b1;


	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;
	   end

	 18:
	   if( isAck != 0 ) i <= 5'd0;
	   else i <= Go;


	 /*****************************/

	 19,20,21,22,23,24,25,26: // Read
	   begin
	      isOut = 1'b0;
	      if( C1 == 150 ) rData[26-i] <= SDA;

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 100 ) rSCL <= 1'b1;

	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= i + 1'b1; end
	      else C1 <= C1 + 1'b1;

	   end

	 27: // no acknowledge
	   begin
	      isOut = 1'b1;
	      //if( C1 == 100 ) isAck <= SDA;

	      if( C1 == 0 ) rSCL <= 1'b0;
	      else if( C1 == 100 ) rSCL <= 1'b1;

	      if( C1 == FREQ -1 ) begin C1 <= 9'd0; i <= Go; end
	      else C1 <= C1 + 1'b1;

	   end


	 /*************************************/ // end fucntion


       endcase

endmodule // iic_func_module
