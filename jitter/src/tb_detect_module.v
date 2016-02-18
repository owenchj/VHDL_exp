`timescale 1 ps/ 1 ps
module tb_detect_module();

   reg CLK;
   reg Pin_In;
   reg RSTn;

   wire H2L_Sig;
   wire L2H_Sig;

   /*******************/ //simulation use
   wire SQ_F1;
   wire SQ_F2;
   /*******************/

   /************************/

   detect_module U1
     (
      .CLK( CLK ),
      .RSTn( RSTn ),
      .Pin_In( Pin_In ),
      .H2L_Sig( H2L_Sig ),
      .L2H_Sig( L2H_Sig ),
      /*******************/
      .SQ_F1( SQ_F1 ),
      .SQ_F2( SQ_F2 )
      /*******************/
      );

   /***********************/

   initial
     begin
	RSTn = 0; #1000 RSTn = 1;
	CLK = 1; forever #5 CLK = ~CLK;
     end

   /***********************/

   reg [3:0]i;

   always @( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  Pin_In = 1'b1;
	  i <= 4'd0;
       end
     else
       case( i )

	 0,1:
	   begin Pin_In <= 1'b1; i <= i + 1'b1; end

	 2:
	   begin Pin_In <= 1'b0; i <= i + 1'b1; end

	 3,4:
	   begin i <= i + 1'b1; end

	 5:
	   begin Pin_In <= 1'b1; i <= i; end

       endcase

   /*************************************/

endmodule
