//--------------------------------------------------------------------
// File: cmp.v
// Name: Omkar Girish Kamath
// Date: 17th May 2023 
// Description: Compares values between rA and rB and provides compare
// signal.
//--------------------------------------------------------------------

module cmp (
	    rA,
	    rB,
	    cmp
	    );

   // Compare Results
   localparam EQ = 2'b00;
   localparam LT = 2'b01;
   localparam GT = 2'b10;
   
   //--------------------------------------------------------------------
   // Input Signals
   //--------------------------------------------------------------------
   input wire [7:0] rA;
   input wire [7:0] rB;
   
   //--------------------------------------------------------------------
   // Output Signals
   //--------------------------------------------------------------------
   output reg [1:0] cmp;


   always @(*)
     begin
	if (rA > rB)
	  begin
	     cmp <= GT;
	  end
	else
	  if (rA == rB)
	    begin
	       cmp <= EQ;
	    end
	  else 
	    if (rA < rB)
	      begin
		 cmp <= LT;
	      end
	    else
	      begin
		 cmp <= 2'b11;
	      end
     end
endmodule
   
