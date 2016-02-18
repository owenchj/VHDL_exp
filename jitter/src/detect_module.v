module detect_module
  (
   input  CLK,
   input  RSTn,
   input  Pin_In,
   output H2L_Sig,
   output L2H_Sig,

   /*****************/
   output SQ_F1,SQ_F2
   /*****************/
   );

   /*********************************/

   reg 	  F1,F2;

   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  F1 <= 1'b1;
	  F2 <= 1'b1;
       end
     else
       begin
	  F1 <= Pin_In;
	  F2 <= F1;
       end

   /*********************************/

   assign H2L_Sig = F2 && !F1;
   assign L2H_Sig = F1 && !F2;

   //simulation use
   assign SQ_F1 = F1;
   assign SQ_F2 = F2;

   /*********************************/

endmodule
