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
   output wire [7:0] rA_out;

   // Output signal from rB_mux
   output wire [7:0] rB_out;

   // Output signal for register rM
   output wire [7:0] rM_out;

   // Output address for SRAM ctrl
   output wire [7:0] addr  ;

   //--------------------------------------------------------------------
   // MUX for rA
   //--------------------------------------------------------------------
   mux_8to1 muxrA_0bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[0]),
                       .in1(rA_alu[0]),
                       .in2(rB[0]),
                       .in3(rP[0]),
                       .in4(rA_dq[0]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[0])
                       );   
   mux_8to1 muxrA_1bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[1]),
                       .in1(rA_alu[1]),
                       .in2(rB[1]),
                       .in3(rP[1]),
                       .in4(rA_dq[1]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[1])
                       );
   mux_8to1 muxrA_2bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[2]),
                       .in1(rA_alu[2]),
                       .in2(rB[2]),
                       .in3(rP[2]),
                       .in4(rA_dq[2]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[2])
                       );
   mux_8to1 muxrA_3bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[3]),
                       .in1(rA_alu[3]),
                       .in2(rB[3]),
                       .in3(rP[3]),
                       .in4(rA_dq[3]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[3])
                       );   
   mux_8to1 muxrA_4bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[4]),
                       .in1(rA_alu[4]),
                       .in2(rB[4]),
                       .in3(rP[4]),
                       .in4(rA_dq[4]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[4])
                       );
   mux_8to1 muxrA_5bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[5]),
                       .in1(rA_alu[5]),
                       .in2(rB[5]),
                       .in3(rP[5]),
                       .in4(rA_dq[5]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[5])
                       );   
   mux_8to1 muxrA_6bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[6]),
                       .in1(rA_alu[6]),
                       .in2(rB[6]),
                       .in3(rP[6]),
                       .in4(rA_dq[6]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[6])
                       );
   mux_8to1 muxrA_7bit(
                       .sl(mux_ctrl_rA),
                       .in0(rA_ldi[7]),
                       .in1(rA_alu[7]),
                       .in2(rB[7]),
                       .in3(rP[7]),
                       .in4(rA_dq[7]),
                       .in5(),
                       .in6(),
                       .in7(),
                       .out(rA_out[7])
                       );
   
   //--------------------------------------------------------------------
   // MUX for rB
   //--------------------------------------------------------------------

   mux_2to1 muxrB0bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[0]),
                      .in0(rA[0]),
                      .in1(rM[0])
                      );
   mux_2to1 muxrB1bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[1]),
                      .in0(rA[1]),
                      .in1(rM[1])
                      );
   mux_2to1 muxrB2bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[2]),
                      .in0(rA[2]),
                      .in1(rM[2])
                      );
   mux_2to1 muxrB3bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[3]),
                      .in0(rA[3]),
                      .in1(rM[3])
                      );
   mux_2to1 muxrB4bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[4]),
                      .in0(rA[4]),
                      .in1(rM[4])
                      );
   mux_2to1 muxrB5bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[5]),
                      .in0(rA[5]),
                      .in1(rM[5])
                      );
   mux_2to1 muxrB6bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[6]),
                      .in0(rA[6]),
                      .in1(rM[6])
                      );
   mux_2to1 muxrB7bit(
                      .sl(mux_ctrl_rB),
                      .out(rB_out[7]),
                      .in0(rA[7]),
                      .in1(rM[7])
                      );


   //--------------------------------------------------------------------
   // MUX for rM
   //--------------------------------------------------------------------
   mux_4to1 muxrM0bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[0]),
                      .in0(rA[0]),
                      .in1(rB[0]),
                      .in2(rP[0]),
                      .in3()
                      );
   mux_4to1 muxrM1bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[1]),
                      .in0(rA[1]),
                      .in1(rB[1]),
                      .in2(rP[1]),
                      .in3()
                      );
   mux_4to1 muxrM2bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[2]),
                      .in0(rA[2]),
                      .in1(rB[2]),
                      .in2(rP[2]),
                      .in3()
                      );
   mux_4to1 muxrM3bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[3]),
                      .in0(rA[3]),
                      .in1(rB[3]),
                      .in2(rP[3]),
                      .in3()
                      );
   mux_4to1 muxrM4bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[4]),
                      .in0(rA[4]),
                      .in1(rB[4]),
                      .in2(rP[4]),
                      .in3()
                      );
   mux_4to1 muxrM5bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[5]),
                      .in0(rA[5]),
                      .in1(rB[5]),
                      .in2(rP[5]),
                      .in3()
                      );
   mux_4to1 muxrM6bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[6]),
                      .in0(rA[6]),
                      .in1(rB[6]),
                      .in2(rP[6]),
                      .in3()
                      );
   mux_4to1 muxrM7bit(
                      .sl(mux_ctrl_rM),
                      .out(rM_out[7]),
                      .in0(rA[7]),
                      .in1(rB[7]),
                      .in2(rP[7]),
                      .in3()
                      );

   //--------------------------------------------------------------------
   // MUX for mem addrs
   //--------------------------------------------------------------------
   mux_2to1 muxAddr0bit(
                      .sl(addr_ctrl),
                      .out(addr[0]),
                      .in0(rP[0]),
                      .in1(rM[0])
                      );
   mux_2to1 muxAddr1bit(
                      .sl(addr_ctrl),
                      .out(addr[1]),
                      .in0(rP[1]),
                      .in1(rM[1])
                      );
   mux_2to1 muxAddr2bit(
                      .sl(addr_ctrl),
                      .out(addr[2]),
                      .in0(rP[2]),
                      .in1(rM[2])
                      );
   mux_2to1 muxAddr3bit(
                      .sl(addr_ctrl),
                      .out(addr[3]),
                      .in0(rP[3]),
                      .in1(rM[3])
                      );
   mux_2to1 muxAddr4bit(
                      .sl(addr_ctrl),
                      .out(addr[4]),
                      .in0(rP[4]),
                      .in1(rM[4])
                      );
   mux_2to1 muxAddr5bit(
                      .sl(addr_ctrl),
                      .out(addr[5]),
                      .in0(rP[5]),
                      .in1(rM[5])
                      );
   mux_2to1 muxAddr6bit(
                      .sl(addr_ctrl),
                      .out(addr[6]),
                      .in0(rP[6]),
                      .in1(rM[6])
                      );
   mux_2to1 muxAddr7bit(
                      .sl(addr_ctrl),
                      .out(addr[7]),
                      .in0(rP[7]),
                      .in1(rM[7])
                      );
   
endmodule
