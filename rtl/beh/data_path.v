//--------------------------------------------------------------------
// File: data_path.v
// Name: Omkar Girish Kamath
// Date: 17th May 2023
// Description: Contains all the MUXes
//--------------------------------------------------------------------

module data_path (
		  rA_ldi,
		  rA_alu,
		  rB,
		  rP,
		  rA_dq,
		  mux_ctrl_rA,
		  rA_out,
		  rM,
		  mux_ctrl_rB,
		  rB_out,
		  rA,
		  mux_ctrl_rM,
		  rM_out,
		  addr_ctrl,
		  addr
		  );

   // Input from the registers
   input wire [7:0] rA;
   input wire [7:0] rM;
   input wire [7:0] rB;
   input wire [7:0] rP;

   // Input signal for register rA
   input wire [7:0] rA_ldi;
   input wire [7:0] rA_alu;
   inout wire [7:0] rA_dq;
   input wire [2:0] mux_ctrl_rA; // mux select lines from cpu_control

   // Input signal for register rB
   input wire 	    mux_ctrl_rB; // mux select lines from cpu_control

   // Input signal for register rM
   input wire [1:0] mux_ctrl_rM; // mux select lines from cpu_control

   // Input signal for address
   input wire 	    addr_ctrl;

   // Output signal from rA_mux
   output reg [7:0] rA_out;

   // Output signal from rB_mux
   output reg [7:0] rB_out;

   // Output signal for register rM
   output reg [7:0] rM_out;

   // Output address for SRAM ctrl
   output reg [7:0] addr  ;

   //--------------------------------------------------------------------
   // MUX for rA
   //--------------------------------------------------------------------
   always@ (*)
     begin
	case (mux_ctrl_rA)
	  'd0 :
	    begin
	       rA_out <= rA_ldi; // load immediate instruction
	    end

	  'd1 :
	    begin
	       rA_out <= rA_alu; // result from ALU
	    end

	  'd2 :
	    begin
	       rA_out <= rB; // swap with B
	    end

	  'd3 :
	    begin
	       rA_out <= rP; // copy P to A
	    end

	  'd4 :
	    begin
	       rA_out <= rA_dq; // load from memory instruction
	    end

	  default :
	    begin
	       rA_out <= 'b0;
	    end
	endcase // case (mux_ctrl_rA)

     end // always@ (*)

   //--------------------------------------------------------------------
   // MUX for rB
   //--------------------------------------------------------------------
   always@ (*)
     begin
	case (mux_ctrl_rB)
	  'd0 :
	    begin
	       rB_out <= rA; // swap with A
	    end

	  'd1 :
	    begin
	       rB_out <= rM; // swap with M
	    end

	  default :
	    begin
	       rB_out <= 'b0;
	    end
	endcase // case (mux_ctrl_rB)

     end // always@ (*)

   //--------------------------------------------------------------------
   // rP either increments itself or takes value of rM, hence no MUX
   //--------------------------------------------------------------------
   // input wire

   // //MUX for rP
   //  always@ (*)
   //   begin
   // 	case (mux_ctrl_rB)
   // 	  'd0 :
   // 	    begin
   // 	       rB_out <= rA;
   // 	    end

   // 	  'd1 :
   // 	    begin
   // 	       rB_out <= rM;
   // 	    end

   // 	  default :
   // 	    begin
   // 	       rB_out <= 'b0;
   // 	    end
   // 	endcase // case (mux_ctrl_rB)

   //   end // always@ (*)

   //--------------------------------------------------------------------
   // MUX for rM
   //--------------------------------------------------------------------
   always@ (*)
     begin
	case (mux_ctrl_rM)
	  'd0 :
	    begin
	       rM_out <= rA; // swap with A
	    end

	  'd1 :
	    begin
	       rM_out <= rB; // swap with B
	    end

	  'd2 :
	    begin
	       rM_out <= rP; // swap with B
	    end

	  default :
	    begin
	       rM_out <= 'b0;
	    end
	endcase // case (mux_ctrl_rM)

     end // always@ (*)

   //--------------------------------------------------------------------
   // MUX for mem addrs
   //--------------------------------------------------------------------
   always@ (*)
     begin
	case (addr_ctrl)
	  'd0 :
	    begin
	       addr <= rP;
	    end

	  'd1 :
	    begin
	       addr <= rM;
	    end

	  default :
	    begin
	       addr <= rP;
	    end
	endcase // case (addr_ctrl)

     end // always@ (*)

endmodule
