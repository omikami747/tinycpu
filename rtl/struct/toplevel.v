module toplevel (
		 rst,
		 clk,
		 addr,
		 cen,
		 wen,
		 oen,
		 dq     ///// Need to fix wires connecting rA , SRAN controller ask Uncle
		 );

   input wire rst;
   input wire clk;


   output wire [7:0] addr;
   output wire 	     cen;
   output wire 	     wen;
   output wire 	     oen;
   inout wire [7:0]  dq;


   //--------------------------------------------------------------------
   // Internal Wires
   //--------------------------------------------------------------------
   
   wire [7:0] 	     dq_sram ;
   wire [1:0] 	     cmp_in;
   wire [2:0] 	     mux_rA_o;
   wire  	     mux_rB_o;
   wire [1:0] 	     mux_rM_o;
   wire  	     den_o;
   wire  	     cen_o;
   wire  	     wen_o;
   wire  	     oen_o;
   wire [1:0] 	     alu_ctrl_o;
   wire  	     rP_inc_o;
   wire  	     rP_load_o;
   wire  	     addr_ctrl_o;
   wire  	     rA_we_o;
   wire  	     rB_we_o;
   wire  	     rM_we_o;
   wire [7:0] 	     rA_out_o;
   wire [7:0] 	     rA_o;
   wire [7:0] 	     rB_in_o;
   wire [7:0] 	     rB_o;
   wire [7:0] 	     rM_o;
   wire [7:0] 	     rP_o;
   wire [7:0] 	     rM_in_o;
   wire [7:0] 	     addr_out;
   wire [7:0] 	     rA_mux_1;



   cpu_ctrl cpu_ctrl(
		     .dq(dq_sram),     // input from sram_ctrl
		     .rst(rst),
		     .clk(clk),
		     .cmp(cmp_in),      // compare result sig in
		     .mux_rA(mux_rA_o),   // control sig for register MUXes
		     .mux_rB(mux_rB_o),
		     .mux_rM(mux_rM_o),
		     .den(den_o),      // control sig for SRAM ctrl
		     .cen(cen_o),      
		     .wen(wen_o),
		     .oen(oen_o),      
		     .alu_ctrl(alu_ctrl_o), // control sig for ALU
		     .rP_inc(rP_inc_o),   // control sig for rP
		     .rP_load(rP_load_o),  
		     .addr_ctrl(addr_ctrl_o), // address control signal to SRAM ctrl
		     .rA_we(rA_we_o),
		     .rB_we(rB_we_o),
		     .rM_we(rM_we_o)
		     );
   cpu_reg cpu_reg (
		    .rst(rst),
		    .clk(clk),
		    .rA_in(rA_out_o),
		    .rA_we(rA_we_o),
		    .rA_out(rA_o),
		    .rB_in(rB_in_o),
		    .rB_we(rB_we_o),
		    .rB_out(rB_o),
		    .rP_rM(rM_o),
		    .rP_inc(rP_inc_o),
		    .rP_load(rP_load_o),
		    .rP_out(rP_o),
		    .rM_in(rM_in_o),
		    .rM_we(rM_we_o),
		    .rM_out(rM_o)
      
		    );
   data_path  data_path(
			.rA_ldi({rA_o[3:0],cpu_ctrl.inst[3:0]}),
			.rA_alu(rA_mux_1),
			.rB(rB_o),
			.rP(rP_o),
			.rA_dq(dq_sram),
			.mux_ctrl_rA(mux_rA_o),
			.rA_out(rA_out_o),
			.rM(rM_o),
			.mux_ctrl_rB(mux_rB_o),
			.rB_out(rB_in_o),
			.rA(rA_o),
			.mux_ctrl_rM(mux_rM_o),
			.rM_out(rM_in_o),
			.addr_ctrl(addr_ctrl_o),
			.addr(addr_out)
			);
   sram_ctrl sram_ctrl(
		       .clk(clk),
		       .rst(rst),
		       .dq_out(dq),       // sram control to sram signals
		       .addr_out(addr),
		       .cen_out(cen),
		       .wen_out(wen),
		       .oen_out(oen),
		       .cen_in(cen_o),
		       .wen_in(wen_o),
		       .oen_in(oen_o),
		       .den_in(den_o),       // tristate buffer control
		       .addr_in(addr_out),      // input address from addr mux
		       .rA(rA_o),
		       .rA_mux_in(dq_sram)
		       );
   alu alu(
	   .alu_ctrl(alu_ctrl_o),
	   .rA_in(rA_o),
	   .rB_in(rB_o),
	   .rA_out(rA_mux_1)
	   );
   cmp cmp(
	   .rA(rA_o),
	   .rB(rB_o),
	   .cmp(cmp_in)
	   );
   
endmodule
