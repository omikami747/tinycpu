//--------------------------------------------------------------------
// File: mux_2to1.v
// Name: Omkar Girish Kamath
// Date: 15th June 2023
// Description: A 2 input to 1 output multiplexer with 1 bit select  
//              line.
//--------------------------------------------------------------------

module mux_2to1 (
                 sl,
                 out,
                 in0,
                 in1
                 );

   //--------------------------------------------------------------------
   // Inputs
   //--------------------------------------------------------------------
   input wire sl;
   input wire in0;
   input wire in1;

   //--------------------------------------------------------------------
   // Outputs
   //--------------------------------------------------------------------
   output reg out;
   
   always @(*)
     begin
        case (sl)
          'b0:
            begin
               out <= in0;
            end
          
          'b1:
            begin
               out <= in1;
            end
          
          default:
            begin
               out <= in0;
            end
        endcase  
     end // always @ (*)
   
endmodule
