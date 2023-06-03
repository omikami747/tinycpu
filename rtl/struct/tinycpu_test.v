module tinycpu_test;

   reg clk;
   reg reset;

   initial
     begin
	$dumpfile("structural_dump.vcd");
        $dumpvars;
	clk <= 1'b0;
	reset <= 1'b0;
	#10;
	reset <= 1'b1;
        // Remove once implementation is verified.
       #100000;
       $finish;
     end

   always
     begin
	#5;
	clk <= 1'b1;
	#5;
	clk <= 1'b0;
     end

   always @(posedge clk)
     begin


	if (cpumodel.toplevel.cpu_ctrl.state == 3'd2
            && cpumodel.toplevel.cpu_ctrl.inst[7:6] == 2'b11
            && (cpumodel.toplevel.cpu_reg.rP_out - 1) == cpumodel.toplevel.cpu_reg.rM_out
            && reset == 1'b1)
          begin
             $display("Detected forever loop, halting CPU.");
             $finish;
          end
	if  (cpumodel.toplevel.cpu_ctrl.state == 3'd0 && reset == 1'b1)
          begin
             $display("A = %x, B = %x, M = %x, P = %x",
                      cpumodel.toplevel.cpu_reg.rA_out, cpumodel.toplevel.cpu_reg.rB_out, cpumodel.toplevel.cpu_reg.rM_out, cpumodel.toplevel.cpu_reg.rP_out);
          end
     end

   sim_env cpumodel
     (.clk(clk),
      .rst(reset)
      );

endmodule // tinycpu_test
