//--------------------------------------------------------------------
// File: cpu_reg.v
// Name: Omkar Girish Kamath
// Date: 17th May 2023 
// Description: Contains all the CPU registers 
//--------------------------------------------------------------------

module cpu_reg (
		rst,
		clk,
		rA_in,
		rA_we,
		rA_out,
		rB_in,
		rB_we,
		rB_out,
		rP_rM,
		rP_inc,
		rP_load,
		rP_out,
		rM_in,
		rM_we,
		rM_out
		);

   input wire clk;
   input wire rst;
   
   //input signals for rA 
   input wire [7:0] rA_in;
   input wire       rA_we;
   
   //input signals for rB
   input wire [7:0] rB_in;
   input wire 	    rB_we;

   //input signals for rP
   input wire [7:0] rP_rM;
   input wire       rP_load; // for jumps, load value from rM
   input wire       rP_inc; // cpu signal to increment PC 
   
   //input signals for rM
   input wire [7:0] rM_in;
   input wire       rM_we;

   //output signals for rA
   output reg [7:0] rA_out;
   
   //output signals for rB
   output reg [7:0] rB_out;
   
   //output signals for rP
   output reg [7:0] rP_out;
   
   //output signals for rM
   output reg [7:0] rM_out;

   //--------------------------------------------------------------------
   // rA register -> first general purpose register 
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
	if (rst == 1'b0)
	  begin
	     rA_out <= 'b0; 
	  end
	else
	  begin
	     if (rA_we)
	       begin
		  rA_out <= rA_in;
	       end
	  end
     end // always @ (posedge clk or negedge rst)

   //--------------------------------------------------------------------
   // rB register -> second general purpose register 
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
	if (rst == 1'b0)
	  begin
	     rB_out <= 'b0; 
	  end
	else
	  begin
	     begin
		if (rB_we)
		  begin
		     rB_out <= rB_in;
		  end
	     end	     
	  end
     end
   
   //--------------------------------------------------------------------
   // rP register -> program counter register 
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
	if (rst == 1'b0)
	  begin
	     rP_out <= 'b0; 	     
	  end
	else
	  begin
	     begin
		if (rP_inc)
		  begin
		     rP_out <= rP_out + 'b1;
		  end
		else
		  begin
		     if (rP_load)
		       begin
			  rP_out <= rP_rM;
		       end
		  end
	     end
	  end
     end
   
   //--------------------------------------------------------------------
   // rM register -> memory access address register
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
	if (rst == 1'b0)
	  begin
	     rM_out <= 'b0; 	     
	  end
	else
	  begin
	     begin
		if (rM_we)
		  begin
		     rM_out <= rM_in;
		  end
	     end	     
	  end
     end

endmodule
   
