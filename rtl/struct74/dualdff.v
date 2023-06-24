//--------------------------------------------------------------------
// File: dualdff.v
// Name: Omkar Girish Kamath
// Date: 23th June 2023
// Description: IC 7474
//--------------------------------------------------------------------

module dualdff (
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
   
   input wire  pin1;    // rst/clr for 1D(active low)
   input wire  pin2;    // input 1D 
   input wire  pin3;    // clk in for 1D
   input wire  pin4;    // preset for 1D (active low), preset preference over clear
   input wire  pin7;    // GND
   input wire  pin10;   // preset for 2D (active low), preset preference over clear
   input wire  pin11;   // clk in for 2D
   input wire  pin12;   // input 2D
   input wire  pin13;   // rst/clr for 1D(active low)
   input wire  pin14;   // Vcc
   
   output wire pin5;    // Q output for 1D
   output wire pin6;    // ~Q output for 1D
   output wire pin8;    // ~Q output for 2D
   output wire pin9;    // Q output for 2D
   
   reg         dff1;
   reg         dff2;

   always @(posedge pin3 or negedge pin1 or negedge pin4)
     begin
        if (pin4 == 'b0)
          begin
             dff1 <= 1'b1;
          end
        else if (pin1 == 'b0)
          begin
             dff1 <= 1'b0;
          end
        else
          begin
             dff1 <= pin2;
          end
     end

   assign pin5 = dff1;
   assign pin6 = ~dff1;

   always @(posedge pin11 or negedge pin13 or negedge pin10)
     begin
        if (pin10 == 'b0)
          begin
             dff2 <= 1'b1;
          end
        else if (pin13 == 'b0)
          begin
             dff2 <= 1'b0;
          end
        else
          begin
             dff2 <= pin12;
          end
     end

   assign pin9 = dff2;
   assign pin8 = ~dff2;
   
endmodule
