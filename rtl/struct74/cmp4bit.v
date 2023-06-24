//--------------------------------------------------------------------
// File: cmp4bit.v
// Name: Omkar Girish Kamath
// Date: 24th June 2023
// Description: IC 7485
//--------------------------------------------------------------------

module cmp4bit (
	        pin1,     //  B3
                pin2,     //  A<B in
                pin3,     //  A=B in
                pin4,     //  A>B in
                pin5,     //  A>B out
                pin6,     //  A=B out
                pin7,     //  A<B out
                pin8,     //  GND
                pin9,     //  BO
                pin10,    //  A0
                pin11,    //  B1
                pin12,    //  A1
                pin13,    //  A2
                pin14,    //  B2
                pin15,    //  A3
                pin16     //  Vcc
                );
   
   input wire pin1;
   input wire pin2;
   input wire pin3;
   input wire pin4;
   input wire pin8;
   input wire pin9;
   input wire pin10;
   input wire pin11;   
   input wire pin12;
   input wire pin13;
   input wire pin14;
   input wire pin15;
   input wire pin16;

   
   output wire pin5;
   output wire pin6;
   output wire pin7;
   
   wire [4:0]  A = {pin15,pin13,pin12,pin10,pin4};
   wire [4:0]  B = {pin1,pin14,pin11,pin9,pin2};

   assign pin5 = A > B || ((A == B) && (pin4 == 'b1)) ? 1'b1 : 1'b0;
   assign pin6 = A == B && pin3 == 1'b1 ? 1'b1 : 1'b0;
   assign pin7 = A < B || ((A == B) && (pin2 == 'b1)) ? 1'b1 : 1'b0;
   
endmodule
