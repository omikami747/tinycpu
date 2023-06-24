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
   // localparam EQ = 3'b010;
   // localparam LT = 3'b001;
   // localparam GT = 3'b100;

   //--------------------------------------------------------------------
   // Input Signals
   //--------------------------------------------------------------------
   input wire [7:0] rA;
   input wire [7:0] rB;

   //--------------------------------------------------------------------
   // Output Signals
   //--------------------------------------------------------------------
   output wire [2:0] cmp;

   //--------------------------------------------------------------------
   // Internal Signals
   //--------------------------------------------------------------------
   wire              rA_lsr_rB;
   wire              rA_eq_rB;
   wire              rA_grt_rB;
   
   cmp4bit cmp1 (
                 .pin1(rB[3]),     //  B3
                 .pin2(1'b0),      //  A<B in
                 .pin3(1'b1),      //  A=B in
                 .pin4(1'b0),      //  A>B in
                 .pin5(rA_grt_rB), //  A>B out
                 .pin6(rA_eq_rB),  //  A=B out
                 .pin7(rA_lsr_rB), //  A<B out
                 .pin8(),          //  GND
                 .pin9(rB[0]),     //  BO
                 .pin10(rA[0]),    //  A0
                 .pin11(rB[1]),    //  B1
                 .pin12(rA[1]),    //  A1
                 .pin13(rA[2]),    //  A2
                 .pin14(rB[2]),    //  B2
                 .pin15(rA[3]),    //  A3
                 .pin16()          // Vcc
                 );
   cmp4bit cmp2 (
                 .pin1(rB[7]),      //  B3
                 .pin2(rA_lsr_rB),  //  A<B in
                 .pin3(rA_eq_rB),   //  A=B in
                 .pin4(rA_grt_rB),  //  A>B in
                 .pin5(cmp[2]),     //  A>B out
                 .pin6(cmp[1]),     //  A=B out
                 .pin7(cmp[0]),     //  A<B out
                 .pin8(),           //  GND
                 .pin9(rB[4]),      //  BO
                 .pin10(rA[4]),     //  A0
                 .pin11(rB[5]),     //  B1
                 .pin12(rA[5]),     //  A1
                 .pin13(rA[6]),     //  A2
                 .pin14(rB[6]),     //  B2
                 .pin15(rA[7]),     //  A3
                 .pin16()           //  Vcc
                 );
   
endmodule
