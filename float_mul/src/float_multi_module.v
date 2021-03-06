module float_multi_module
  (
   input 	 CLK, RSTn,
   input [31:0]  A,B,
   output [31:0] Result,

   input 	 Start_Sig,
   output [3:0]  Done_Sig,


   /*****************/

   output [32:0] SQ_rA,SQ_rB,
   output [47:0] SQ_Temp,
   output [9:0]  SQ_rExp,SQ_BDiff


   );
   /**************************************/

   reg [3:0] 	 i;
   reg [32:0] 	 rA,rB; // [32]Sign, [31:24]Exponent, [23]Hidden Bit, [22:0]Mantissa
   reg [47:0] 	 Temp;
   reg [31:0] 	 rResult;
   reg [9:0] 	 rExp,BDiff;
   reg 		 isSign;
   reg 		 isOver;
   reg 		 isUnder;
   reg 		 isZero;
   reg 		 isDone;
   // [48]M'sign, [47:46]Hidden Bit, [45:23]M, [22:0]M'resolution
   //[9:8] Overflow or underflow check, [7:0] usuall exp.


   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  i <= 4'd0;
	  rA <= 33'd0;
	  rB <= 33'd0;
	  Temp <= 48'd0;
	  rResult <= 32'd0;
	  rExp <= 10'd0;
	  BDiff <= 10'd0;
	  isOver <= 1'b0;
	  isUnder <= 1'b0;
	  isZero <= 1'b0;
	  isDone <= 1'b0;

       end // UNMATCHED !!
     else if( Start_Sig )
       case( i )

	 0: // Initial and resulted out Signature
	   begin
	      rA <= { A[31], A[30:23], 1'b1, A[22:0]};
	      rB <= { B[31], B[30:23], 1'b1, B[22:0]};
	      isSign <= A[31] ^ B[31];

	      isOver <= 1'b0; isUnder <= 1'b0; isZero <= 1'b0;
	      i <= i + 1'b1;

	   end

	 1:
	   begin

	      if( rA[31:24] == rB[31:24] && ( rA[22:0] != 23'd0 & rB[22:0] != 23'd0 ) || rA[32] ^ rB[32] )

		begin rB[31:24] <= rB[31:24] + 1'b1; rB[23:0] <= rB[23:0] >> 1; end


	      i <= i + 1'b1;
	   end // UNMATCHED !!
	 2: // if rExp[9..8] is 1, mean A.Exp small than B.Exp


	   // while rExp[9..8] is 0, mean A.Exp large than B.Exp or same.
	   begin
	      BDiff = rB[31:24] - 8'd127; // + (~8'd127 + 1)
	      rExp <= rA[31:24] + BDiff; // A.Exp + B.Exp
	      i <= i + 1'b1;

	   end

	 3:
	   begin

	      Temp <= rA[23:0] * rB[23:0];


	      i <= i + 1'b1;
	   end

	 4: // Check M'hidden bit
	   begin
	      if( Temp[47] == 1'b1 ) begin Temp <= Temp; end // do nothing
	      else if( Temp[46] == 1'b1 ) begin Temp <= Temp << 1; end
	      else if( Temp[45] == 1'b1 ) begin Temp <= Temp << 2; rExp <= rExp - 1'b1;end



	      i <= i + 1'b1;
	   end // UNMATCHED !!
	 5: //error check and decide final result
	   begin
	      if( rExp[9:8] == 2'b01 ) begin isOver <= 1'b1; rResult <= {1'b0,8'd127, 23'd0}; end
	      else if( rExp[9:8] == 2'b11 ) begin isUnder <= 1'b1; rResult <= {1'b0, 8'd127, 23'd0}; end // E Underflow
	      else if( Temp[47:24] == 24'd0 ) begin isZero <= 1'b1; rResult <= {1'b0, 8'd127, 23'd0}; end // M Zero
	      else if( Temp[23] == 1'b1 ) rResult <= { isSign, rExp[7:0], Temp[46:24] + 1'b1 }; // okay with normalised
	      else rResult <= { isSign, rExp[7:0], Temp[46:24] }; // okay without normalise
	      i <= i + 1'b1;

	      // E Overflow
	   end

	 6:
	   begin isDone <= 1'b1; i <= i + 1'b1; end

	 7:
	   begin isDone <= 1'b0; i <= 4'd0; end


       endcase


   /**************************************/
   assign Done_Sig = { isOver, isUnder, isZero, isDone };
   assign Result = rResult;


   /***************************************/

   assign SQ_rA = rA;
   assign SQ_rB = rB;
   assign SQ_rExp = rExp;
   assign SQ_BDiff = BDiff;
   assign SQ_Temp = Temp;


   /****************************************/

endmodule
