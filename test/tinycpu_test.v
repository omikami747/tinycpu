module tinycpu_test;

`ifdef BEH
   `define DUMP_NAME "beh_dump.vcd"
   `define TOPLEVEL tinycpu
   `define STATE cpumodel.exec_state
   `define INSTR cpumodel.instr[7:6]
   `define RA cpumodel.rA
   `define RB cpumodel.rB
   `define RM cpumodel.rM
   `define RP cpumodel.rP
  `else
   `define DUMP_NAME "str_dump.vcd"
   `define TOPLEVEL sim_env
   `define STATE cpumodel.toplevel.cpu_ctrl.state
   `define INSTR cpumodel.toplevel.cpu_ctrl.inst[7:6]
   `define RA cpumodel.toplevel.cpu_reg.rA_out
   `define RB cpumodel.toplevel.cpu_reg.rB_out
   `define RM cpumodel.toplevel.cpu_reg.rM_out
   `define RP cpumodel.toplevel.cpu_reg.rP_out
 // `ifdef STR74
 // `endif  //space for STR74 implementation
`endif // !`ifdef BEH

   reg clk;
   reg reset;

   initial
     begin
        $dumpfile(`DUMP_NAME);
        $dumpvars;
        clk <= 1'b0;
        reset <= 1'b0;
        #10;
        reset <= 1'b1;
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
        if (`STATE == 3'd2
            && `INSTR == 2'b11
            && (`RP - 1) == `RM
            && reset == 1'b1)
          begin
             $display("Detected forever loop, halting CPU.");
             $finish;
          end
        if (`STATE == 3'd0 && reset == 1'b1)
          begin
             $display("A = %x, B = %x, M = %x, P = %x",
                      `RA, `RB, `RM, `RP);
          end
     end

   `TOPLEVEL cpumodel
     (.clk(clk),
      .reset(reset)
      );

endmodule // tinycpu_test
