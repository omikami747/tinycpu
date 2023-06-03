module sim_env(
               input clk,
               input reset
               );

   wire 		     cen;
   wire 		     wen;
   wire 		     oen;
   wire [7:0] 		     addr;
   wire [7:0] 		     dq;

   toplevel toplevel(
		     .rst(reset),
		     .clk(clk),
		     .addr(addr),
		     .cen(cen),
		     .wen(wen),
		     .oen(oen),
		     .dq(dq)
		     );

   sram sram(
	     .addr(addr),
	     .cen(cen),
	     .wen(wen),
	     .oen(oen),
	     .dq(dq)
	     );
endmodule
