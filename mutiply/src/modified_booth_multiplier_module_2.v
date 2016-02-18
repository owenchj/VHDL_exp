module modified_booth_multiplier_module_2
  (

   input 	 CLK,

   input 	 RSTn,

   input 	 Start_Sig,
   input [7:0] 	 A,
   input [7:0] 	 B,

   output 	 Done_Sig,
   output [15:0] Product


   );


   /*************************/

   reg [3:0] 	 i;
   reg [15:0] 	 a;
   reg [15:0] 	 a2;
   reg [15:0] 	 s; // reverse result of rA
   reg [15:0] 	 s2;

   reg [15:0] 	 p;
   reg [3:0] 	 M;
   reg [8:0] 	 N;
   
   // operation register
   reg 		 isDone;




   always @ ( posedge CLK or negedge RSTn )
     if( !RSTn )
       begin
	  i <= 4'd0;
	  a <= 8'd0;
	  a2 <= 9'd0;
	  s <= 8'd0;
	  s2 <= 9'd0;
	  p <= 16'd0;
	  M <= 4'd0;
	  N <= 9'd0;
	  isDone <= 1'b0;
       end
   
     else if( Start_Sig )

       case( i )

	 0:
	   begin
	      a <= A[7] ? { 8'hFF , A } : { 8'd0 , A };
	      a2 <= A[7] ? { 8'hFF , A + A } : { 8'd0 , A + A };
	      s <= ~A[7] ? { 8'hFF , ( ~A + 1'b1 ) } : { 8'd0 , ( ~A + 1'b1 ) };
	      s2 <= ~A[7] ? { 8'hFF , ( ~A + 1'b1 ) + ( ~A + 1'b1 ) } : { 8'd0 , ( ~A + 1'b1 ) + ( ~A + 1'b1 ) };
	      p <= 16'd0;
	      M <= 4'd0;
	      N <= { B , 1'b0 };
	      i <= i + 1'b1;

	   end

	 1,2,3,4:
	   begin

	      if( N[2:0] == 3'b001 || N[2:0] == 3'b010 ) p <= p + ( a << M );
	      else if( N[2:0] == 3'b011 ) p <= p + ( a2 << M ) ;
	      else if( N[2:0] == 3'b100 ) p <= p + ( s2 << M ) ;
	      else if( N[2:0] == 3'b101 || N[2:0] == 3'b110 ) p <= p + ( s << M );

	      M <= M + 2'd2;
	      N <= ( N >> 2 );
	      i <= i + 1'b1;
	   end

	 5:
	   begin isDone <= 1'b1; i <= i + 1'b1; end

	 6:
	   begin isDone <= 1'b0; i <= 4'd0; end


       endcase


   /*************************/

   assign Done_Sig = isDone;
   assign Product = p;



endmodule
