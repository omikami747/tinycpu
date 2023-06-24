//--------------------------------------------------------------------
// File: hex_inv.v
// Name: Omkar Girish Kamath
// Date: 16th June 2023
// Description: IC 7404 
//--------------------------------------------------------------------

module hex_inv (
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
   input wire  pin3;
   input wire  pin5;
   input wire  pin9;
   input wire  pin11;
   input wire  pin13;
   input wire  pin7;
   input wire  pin14;
   
   output wire pin2;
   output wire pin4;
   output wire pin6;
   output wire pin8;
   output wire pin10;
   output wire pin12;
   
   assign pin2 = ~pin1;
   assign pin4 = ~pin3;
   assign pin6 = ~pin5;
   assign pin8 = ~pin9;
   assign pin10 = ~pin11;
   assign pin12 = ~pin13;
   
endmodule
