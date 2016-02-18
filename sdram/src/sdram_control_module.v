module sdram_control_module
  (
   input 	CLK,
   input 	RSTn,

   input 	WrEN_Sig,
   input 	RdEN_Sig,
   output 	Done_Sig,
   output 	Busy_Sig,

   input 	Init_Done_Sig,
   input 	Func_Done_Sig,
   input 	AR_Done_Sig,

   output 	Init_Start_Sig,
   output [2:0] Func_Start_Sig

   );


   /*********************************/


   parameter T15US = 9'd100;


   /*********************************/

   reg [21:0] 	C1;
   reg 		isRef;



   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )


       begin C1 <= 22'd0; isRef <= 1'b0; end
     else if( isRef && AR_Done_Sig )


       begin C1 <= 22'd0; isRef <= 1'b0; end
     else if( C1 == T15US )


       begin C1 <= 22'd0; isRef <= 1'b1; end
     else if( !isRef )

       C1 <= C1 + 1'b1;


   /************************************/

   reg [2:0] i;
   reg [2:0] isStart; //[2] Auto Refresh , [1] Read Action, [0] Write Action
   reg 	     isInit;
   reg 	     isBusy;
   reg 	     isDone;


   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )

       begin

	  i <= 3'd5;
	  isStart <= 3'b000;
	  isInit <= 1'b0;
	  isBusy <= 1'b1;
	  isDone <= 1'b0;
	  // Initial SDRam at first
       end
     else
       case( i )

	 0: // IDLE state
	   if( isRef ) begin isStart <= 3'b100; i <= 3'd1; end
	   else if( RdEN_Sig ) begin isStart <= 3'b010; i <= 3'd2; end // Write enable
	   else if( WrEN_Sig ) begin isStart <= 3'b001; i <= 3'd2; end // Read enable

	 1: // Auto Refresh Done
	   if( AR_Done_Sig ) begin isStart <= 3'd0; i <= 3'd0; end

	 2: // Func Done
	   if( Func_Done_Sig ) begin isStart <= 3'd0; i <= i + 1'b1; end


	 /***************************************/

	 3: // Generate Done Signal
	   begin isDone <= 1'b1; i <= i + 1'b1; end

	 4:
	   begin isDone <= 1'b0; i <= 3'd0; end


	 /******************************************/

	 5: // Initial SDRam
	   if( Init_Done_Sig ) begin isBusy <= 1'b0; isInit <= 1'b0; i <= 3'd0; end
	   else begin isBusy <= 1'b1; isInit <= 1'b1; end


       endcase


   /***************************************/

   assign Init_Start_Sig = isInit;
   assign Func_Start_Sig = isStart;
   assign Done_Sig = isDone;

   
   assign Busy_Sig = isBusy;


   /***************************************/

endmodule
