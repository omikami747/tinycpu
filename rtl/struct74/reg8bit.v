//--------------------------------------------------------------------
// File: reg8bit.v
// Name: Omkar Girish Kamath
// Date: 16th June 2023
// Description: IC 74377 
//--------------------------------------------------------------------

module reg8bit (
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
                pin14,
                pin15,
                pin16,
                pin17,
                pin18,
                pin19,
                pin20
                );
   
   input wire  pin1;
   input wire  pin3;
   input wire  pin4;
   input wire  pin7;
   input wire  pin8;
   input wire  pin10;
   input wire  pin11;
   input wire  pin13;
   input wire  pin14;
   input wire  pin17;
   input wire  pin18;
   input wire  pin20;
   
   output reg pin2;
   output reg pin5;
   output reg pin6;
   output reg pin9;
   output reg pin12;
   output reg pin15;
   output reg pin16;
   output reg pin19;
   
   always @(posedge pin11)
     begin
        if (pin1 == 1'b0)
          begin
             {pin2,pin5,pin6,pin9,pin12,pin15,pin16,pin19} <=
                                                         {pin3,pin4,pin7,pin8,pin13,pin14,pin17,pin18};
        
          end
     end
endmodule
