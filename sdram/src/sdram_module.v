module sdram_module
  (
   input 	 CLK,
   input 	 RSTn,

   input 	 WrEN_Sig,
   input 	 RdEN_Sig,
   output 	 Done_Sig,
   output 	 Busy_Sig,

   input [21:0]  BRC_Addr,
   input [15:0]  WrData,
   output [15:0] RdData,

   output [4:0]  SDRAM_CMD,
   output [13:0] SDRAM_BA,
   inout [15:0]  SDRAM_DATA,

   output 	 SDRAM_LDQM,
   output 	 SDRAM_UDQM

   );


   /***********************************/

   wire 	 Init_Start_Sig;
   wire [2:0] 	 Func_Start_Sig;
   wire [15:0] 	 Func_Write_Data;

   wire 	 Init_Done_Sig;
   wire 	 Func_Done_Sig;
   wire 	 AR_Done_Sig;
   sdram_control_module U1
     (
      .CLK( CLK ), 
      .RSTn( RSTn ), 
      .WrEN_Sig( WrEN_Sig ), 
      .RdEN_Sig( RdEN_Sig ), // input - from top
      .Done_Sig( Done_Sig ), // output - to top
      .Busy_Sig( Busy_Sig ), // output - to top
      .Init_Done_Sig( Init_Done_Sig ), // input - from U2
      .Func_Done_Sig( Func_Done_Sig ), // input - from U3
      .AR_Done_Sig( AR_Done_Sig ), // input - from U3
      .Init_Start_Sig( Init_Start_Sig ), // output - to U2
      .Func_Start_Sig( Func_Start_Sig ) // output - to U3
      // input - from top
      );


   /***********************************/

   wire [4:0] 	 U2_SDRAM_CMD;
   wire [13:0] 	 U2_SDRAM_BA;

   sdram_init_module U2
     (
      .CLK( CLK ),
      .RSTn( RSTn ), 
      .Init_Start_Sig( Init_Start_Sig ), // input - from U1
      .Init_Done_Sig( Init_Done_Sig ), // output - to U1
      .SDRAM_CMD( U2_SDRAM_CMD ), // output - to selector
      .SDRAM_BA( U2_SDRAM_BA ) // output - to selector

      );


   /***********************************/

   wire [15:0] 	 Func_Read_Data;
   wire [4:0] 	 U3_SDRAM_CMD;
   wire [13:0] 	 U3_SDRAM_BA;

   sdram_func_module U3
     (
      .CLK( CLK ),
      .RSTn( RSTn ),
      .Func_Start_Sig( Func_Start_Sig ), // input - from U1
      .Func_Done_Sig( Func_Done_Sig ), // output - to U1
      .AR_Done_Sig( AR_Done_Sig ),
      .BRC_Addr( BRC_Addr ), // input - from top
      .WrData( WrData ), // input - from top
      .RdData( RdData ), // output - to top
      .SDRAM_CMD( U3_SDRAM_CMD ), // output - to selector
      .SDRAM_BA( U3_SDRAM_BA ), // output - to selector
      .SDRAM_DATA( SDRAM_DATA ), // output - to top
      .SDRAM_LDQM( SDRAM_LDQM ),
      .SDRAM_UDQM( SDRAM_UDQM )

      );


   /************************************/


   //Selector of SDRAM_CMD pin and SDRAM_BA pin

   reg [4:0] 	 rCMD;
   reg [13:0] 	 rBA;


   always @ ( * )
     if( Init_Start_Sig ) begin rCMD = U2_SDRAM_CMD; rBA = U2_SDRAM_BA; end
     else if( Func_Start_Sig ) begin rCMD = U3_SDRAM_CMD; rBA = U3_SDRAM_BA; end
     else begin rCMD = 5'bxxxxx; rBA = 14'bxxxxxxxxxxxxxx; end

   assign SDRAM_CMD = rCMD;
   assign SDRAM_BA = rBA;


   /************************************/

   //assign SQ_Init_Start_Sig = Init_Start_Sig;
   //assign SQ_Init_Done_Sig = Init_Done_Sig;
   //assign SQ_Op_Start_Sig = Op_Start_Sig;
   //assign SQ_Op_Done_Sig = Op_Done_Sig;


   /************************************/

endmodule

