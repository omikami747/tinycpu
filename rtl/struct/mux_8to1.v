//--------------------------------------------------------------------
//
//
//--------------------------------------------------------------------

module mux_8to1
  (
   sl,
   out,
   in0,
   in1,
   in2,
   in3,
   in4,
   in5,
   in6,
   in7
   );
   
   //--------------------------------------------------------------------
   // Inputs
   //--------------------------------------------------------------------
   input wire [2:0] sl;
   input wire       in0;
   input wire       in1;
   input wire       in2;
   input wire       in3;
   input wire       in4;
   input wire       in5;
   input wire       in6;
   input wire       in7;
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

          'd4:
            begin
               out <= in4;
            end
          
          'd5:
            begin
               out <= in5;
            end

          'd6:
            begin
               out <= in6;
            end
          
          'd7:
            begin
               out <= in7;
            end
          
          default:
            begin
               out <= in0;
            end
        endcase  
     end // always @ (*)

endmodule
