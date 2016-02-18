`timescale 1 ps/ 1 ps
module tb_float_multi();

   reg CLK;
   reg RSTn;

   reg [31:0] A;
   reg [31:0] B;
   reg 	      Start_Sig;

   wire [3:0] Done_Sig;
   wire [31:0] Result;


   /**************************/

   wire [9:0]  SQ_BDiff;
   wire [47:0] SQ_Temp;
   wire [32:0] SQ_rA;
   wire [32:0] SQ_rB;
   wire [9:0]  SQ_rExp;


   /**************************/



   float_multi_module U1
     (

      .CLK(CLK),
      .RSTn(RSTn),
      .A(A),
      .B(B),
      .Result(Result),
      .Start_Sig(Start_Sig),
      .Done_Sig(Done_Sig),
      /************************/
      .SQ_BDiff(SQ_BDiff),
      .SQ_Temp(SQ_Temp),
      .SQ_rA(SQ_rA),
      .SQ_rB(SQ_rB),
      .SQ_rExp(SQ_rExp)

      );


   /*****************************/


   initial
     begin
	RSTn = 0; #10 RSTn = 1;
	CLK = 0; forever #5 CLK = ~CLK;

     end


   /******************************/


   reg [5:0]i;


   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  A <= 32'd0;
	  B <= 32'd0;
	  Start_Sig <= 1'b0;
	  i <= 6'd0;



       end
     else
       case( i )

	 0: //A=2.5 , B=5, A+B = ?
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000001000000000000000000000; B <= 32'b01000000101000000000000000000000; Start_Sig <= 1'b1; end

	 1:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 2: //3.142 * 3.142
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000010010010001011010000111; B <= 32'b01000000010010010001011010000111; Start_Sig <= 1'b1; end

	 3:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end // UNMATCHED !!
	 4: //12.662 * 4.903
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000001010010101001011110001101; B <= 32'b01000000100111001110010101100000; Start_Sig <= 1'b1; end

	 5:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 6: // 2 * 2
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000000000000000000000000000; B <= 32'b01000000000000000000000000000000; Start_Sig <= 1'b1; end

	 7:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);


	      i <= i + 1'b1;
	   end

	 8: // 3.142 * 2
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000010010010001011010000111; B <= 32'b01000000000000000000000000000000; Start_Sig <= 1'b1; end

	 9:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 10: // 73.767 * 83.266
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000010100100111000100010110100; B <= 32'b01000010101001101000100000110001; Start_Sig <= 1'b1; end


	 11:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 12: // 83.266 * 83.266
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000010101001101000100000110001; B <= 32'b01000010101001101000100000110001; Start_Sig <= 1'b1; end

	 13:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 14: // 1024 * 256
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000100100000000000000000000000; B <= 32'b01000011100000000000000000000000; Start_Sig <= 1'b1; end

	 15:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 16: // 33.116 * 16.558
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000010000001000111011011001001; B <= 32'b01000001100001000111011011001001; Start_Sig <= 1'b1; end

	 17:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;
	   end

	 18: // 0.00416 * 0.00014
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b00111011100010000101000010011100; B <= 32'b00111001000100101100110011110111; Start_Sig <= 1'b1; end

	 19:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 20: // 0.125 * 0.125
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b00111110000000000000000000000000; B <= 32'b00111110000000000000000000000000; Start_Sig <= 1'b1; end

	 21:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 22: // 0.0868 * 0.0868
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b00111101101100011100010000110011; B <= 32'b00111101101100011100010000110011; Start_Sig <= 1'b1; end

	 23:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 24: // 0.0868 * 0.01085
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b00111101101100011100010000110011; B <= 32'b00111100001100011100010000110011; Start_Sig <= 1'b1; end

	 25:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 26: // 0.0078125 * 0.0057488
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b00111100000000000000000000000000; B <= 32'b00111011101111000110000011010001; Start_Sig <= 1'b1; end

	 27:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end


	 28: // 3.1828 * -0.0063
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000010010111011001011111111; B <= 32'b10111011110011100111000000111011; Start_Sig <= 1'b1; end

	 29:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 30: // 6.631 * 0.25
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000110101000011000100100111; B <= 32'b00111110100000000000000000000000; Start_Sig <= 1'b1; end

	 31:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;
	   end

	 32: // 6.3565 * -0.0063
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end

	   else begin A <= 32'b01000000110010110110100001110011; B <= 32'b10111011110011100111000000111011; Start_Sig <= 1'b1; end

	 33:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 34: // 273.757 * 483.265
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000011100010001110000011100101; B <= 32'b01000011111100011010000111101100; Start_Sig <= 1'b1; end

	 35:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 36: // 3.1828 * 2
	   if( Done_Sig[0] ) begin Start_Sig <= 1'b0; i <= i + 1'b1; end
	   else begin A <= 32'b01000000010010111011001011111111; B <= 32'b01000000000000000000000000000000; Start_Sig <= 1'b1; end

	 37:
	   begin
	      $display("A = %b and rA = %b", A,SQ_rA);
	      $display("B = %b and rB = %b", B,SQ_rB);
	      $display("A.m * B.m = %b", SQ_Temp);
	      $display("Result = %b", Result);
	      i <= i + 1'b1;

	   end

	 48:
	   i <= i;
       endcase

endmodule
