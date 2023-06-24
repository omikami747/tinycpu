//--------------------------------------------------------------------
// File: quador.v
// Name: Omkar Girish Kamath
// Date: 20th June 2023
// Description: IC 7432
//--------------------------------------------------------------------

module quador (
               pin1,
               pin2,
               pin3,
               pin4,
               pin5,
               pin6,
               pin7,
               pin8,
               pin9,
               pin10,
               pin11,
               pin12,
               pin13,
               pin14
               );
   
   input wire  pin1;
   input wire  pin2;
   input wire  pin4;
   input wire  pin5;
   input wire  pin7;
   input wire  pin9;
   input wire  pin10;
   input wire  pin12;
   input wire  pin13;
   input wire  pin14;
   
   output wire pin3;
   output wire pin6;
   output wire pin8;
   output wire pin11;
   
   assign pin3 = pin2 || pin1;     // 3 = 2 || 1
   assign pin6 = pin5 || pin4;     // 6 = 5 || 4
   assign pin8 = pin10 || pin9;    // 8 = 10 || 9
   assign pin11 = pin13 || pin12;  // 11 = 13 || 12
   
endmodule
