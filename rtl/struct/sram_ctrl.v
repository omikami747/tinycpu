//--------------------------------------------------------------------
// File: sram_ctrl.v
// Name: Omkar Girish Kamath
// Date: 17th May 2023 
// Description: Provides all the control signals for SRAM.
//--------------------------------------------------------------------

module sram_ctrl(
		 clk,
		 rst,
		 dq_out,       // sram control to sram signals
		 addr_out,
		 cen_out,
		 wen_out,
		 oen_out,
		 cen_in,
		 wen_in,
		 oen_in,
		 den_in,       // tristate buffer control
		 addr_in,      // input address from addr mux
		 rA,
		 rA_mux_in
		 );

   

   //--------------------------------------------------------------------
   // Input
   //--------------------------------------------------------------------
   input wire clk;
   input wire rst;
   input wire [7:0] rA;
   input wire [7:0] addr_in;
   input wire 	    den_in;
   input wire 	    cen_in;
   input wire 	    oen_in;
   input wire 	    wen_in;
   
   //--------------------------------------------------------------------
   // Output
   //--------------------------------------------------------------------   
   output wire 	     cen_out;
   output wire 	     oen_out;
   output wire 	     wen_out;
   output reg [7:0]  addr_out;
   output wire [7:0] rA_mux_in;
   inout wire [7:0]  dq_out ;


   wire [7:0] 	     dq = den_in ? rA : 8'hZZ;
   assign dq_out = dq;
   assign cen_out = cen_in;
   assign oen_out = oen_in;
   assign wen_out = wen_in;
   // assign addr_out = addr_in;
   assign rA_mux_in = dq_out;

   always@ (posedge clk or negedge rst)
     begin
	if (rst == 1'b0)
	  begin
	     addr_out <= 1'b0;
	  end
	else
	  begin
	     addr_out <= addr_in;
	  end
     end
   
endmodule // sram_ctrl
