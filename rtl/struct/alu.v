//--------------------------------------------------------------------
// File: alu.v
// Name: Omkar Girish Kamath
// Date: 19th May 2023 
// Description: Arithmetic and Logic Unit of the processor
//--------------------------------------------------------------------

module alu (
	    alu_ctrl,
	    rA_in,
	    rB_in,
	    rA_out,
	    );
   
   //--------------------------------------------------------------------
   // Calculation Format
   //--------------------------------------------------------------------
   localparam AND = 2'b00;
   localparam OR  = 2'b01;
   localparam INV = 2'b10;
   localparam ADD = 2'b11;
   
   //--------------------------------------------------------------------
   // Input Signals
   //--------------------------------------------------------------------
   input wire [7:0] rA_in;
   input wire [7:0] rB_in;
   input wire [1:0] alu_ctrl;
   
   //--------------------------------------------------------------------
   // Output Signals
   //--------------------------------------------------------------------
   output reg [7:0] rA_out;

   always@ (*)
     begin
	case (alu_ctrl)
	  AND :
	    begin
	       rA_out <= rA_in & rB_in;
	    end

	  OR  :
	    begin
	       rA_out <= rA_in | rB_in;
	    end

	  INV :
	    begin
	       rA_out <= ~rA_in;
	    end

	  ADD :
	    begin
	       rA_out <= rA_in + rB_in;
	    end

	  default :
	    begin
	       rA_out <= rA_in;
	    end
	endcase // case (alu_ctrl)
	
     end
endmodule
