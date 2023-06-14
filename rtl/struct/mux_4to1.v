//--------------------------------------------------------------------
//
//
//--------------------------------------------------------------------

module mux_4to1
  (
   sl,
   out,
   in0,
   in1,
   in2,
   in3
   );

   //--------------------------------------------------------------------
   // Inputs
   //--------------------------------------------------------------------
   input wire [1:0] sl;
   input wire       in0;
   input wire       in1;
   input wire       in2;
   input wire       in3;

   //--------------------------------------------------------------------
   // Outputs
   //--------------------------------------------------------------------
   output reg       out;
   
   always @(*)
     begin
        case (sl)
          'd0:
            begin
               out <= in0;
            end
          
          'd1:
            begin
               out <= in1;
            end

          'd2:
            begin
               out <= in2;
            end
          
          'd3:
            begin
               out <= in3;
            end
          
          default:
            begin
               out <= in0;
            end
        endcase  
     end // always @ (*)
   

endmodule
