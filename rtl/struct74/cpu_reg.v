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
   output wire [7:0] rA_out;

   //output signals for rB
   output wire [7:0] rB_out;

   //output signals for rP
   output reg [7:0] rP_out;

   //output signals for rM
   output wire [7:0] rM_out;

   wire              _rA_we;
   wire              _rB_we;
   wire              _rM_we;
   wire              _rP_we;

   //--------------------------------------------------------------------
   // Register Write Enables invert
   //--------------------------------------------------------------------
   hex_inv inv1(
                .pin1(rA_we),
                .pin2(_rA_we),
                .pin3(rB_we),
                .pin4(_rB_we),
                .pin5(rM_we),
                .pin6(_rM_we),
                .pin7(),
                .pin8(_rP_we),
                .pin9(rP_we),
                .pin10(),
                .pin11(),
                .pin12(),
                .pin13(),
                .pin14()
                );

   
   //--------------------------------------------------------------------
   // rA register -> first general purpose register
   //--------------------------------------------------------------------
   reg8bit reg1 (
                 .pin1(_rA_we),
                 .pin2(rA_out[7]),
                 .pin3(rA_in[7]),
                 .pin4(rA_in[6]),
                 .pin5(rA_out[6]),
                 .pin6(rA_out[5]),
                 .pin7(rA_in[5]),
                 .pin8(rA_in[4]),
                 .pin9(rA_out[4]),
                 .pin10(),
                 .pin11(clk),
                 .pin12(rA_out[3]),
                 .pin13(rA_in[3]),
                 .pin14(rA_in[2]),
                 .pin15(rA_out[2]),
                 .pin16(rA_out[1]),
                 .pin17(rA_in[1]),
                 .pin18(rA_in[0]),
                 .pin19(rA_out[0]),
                 .pin20()
                 );
   // always @(posedge clk or negedge rst)
   //   begin
   //      if (rst == 1'b0)
   //        begin
   //           rA_out <= 'b0;
   //        end
   //      else
   //        begin
   //           if (rA_we)
   //             begin
   //      	  rA_out <= rA_in;
   //             end
   //        end
   //   end // always @ (posedge clk or negedge rst)

   //--------------------------------------------------------------------
   // rB register -> second general purpose register
   //--------------------------------------------------------------------
   reg8bit reg2 (
                 .pin1(_rB_we),
                 .pin2(rB_out[7]),
                 .pin3(rB_in[7]),
                 .pin4(rB_in[6]),
                 .pin5(rB_out[6]),
                 .pin6(rB_out[5]),
                 .pin7(rB_in[5]),
                 .pin8(rB_in[4]),
                 .pin9(rB_out[4]),
                 .pin10(),
                 .pin11(clk),
                 .pin12(rB_out[3]),
                 .pin13(rB_in[3]),
                 .pin14(rB_in[2]),
                 .pin15(rB_out[2]),
                 .pin16(rB_out[1]),
                 .pin17(rB_in[1]),
                 .pin18(rB_in[0]),
                 .pin19(rB_out[0]),
                 .pin20()
                 );
   // always @(posedge clk or negedge rst)
   //   begin
   //      if (rst == 1'b0)
   //        begin
   //           rB_out <= 'b0;
   //        end
   //      else
   //        begin
   //           begin
   //      	if (rB_we)
   //      	  begin
   //      	     rB_out <= rB_in;
   //      	  end
   //           end
   //        end
   //   end

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
   reg8bit reg3 (
                 .pin1(_rM_we),
                 .pin2(rM_out[7]),
                 .pin3(rM_in[7]),
                 .pin4(rM_in[6]),
                 .pin5(rM_out[6]),
                 .pin6(rM_out[5]),
                 .pin7(rM_in[5]),
                 .pin8(rM_in[4]),
                 .pin9(rM_out[4]),
                 .pin10(),
                 .pin11(clk),
                 .pin12(rM_out[3]),
                 .pin13(rM_in[3]),
                 .pin14(rM_in[2]),
                 .pin15(rM_out[2]),
                 .pin16(rM_out[1]),
                 .pin17(rM_in[1]),
                 .pin18(rM_in[0]),
                 .pin19(rM_out[0]),
                 .pin20()
                 );
   // always @(posedge clk or negedge rst)
   //   begin
   //      if (rst == 1'b0)
   //        begin
   //           rM_out <= 'b0;
   //        end
   //      else
   //        begin
   //           begin
   //      	if (rM_we)
   //      	  begin
   //      	     rM_out <= rM_in;
   //      	  end
   //           end
   //        end
   //   end

endmodule
