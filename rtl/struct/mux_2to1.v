module mux_2to1(
                sl,
                out,
                in0,
                in1
                );
   
   input wire sl;
   input wire in0;
   input wire in1;

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
