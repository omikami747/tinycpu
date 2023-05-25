module tinycpu_test;

  reg clk;
  reg reset;

  initial
    begin
      $dumpvars;
      clk <= 1'b0;
      reset <= 1'b0;
      #10;
      reset <= 1'b1;
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
      if (cpumodel.exec_state == 3'd2
          && cpumodel.instr[7:6] == 2'b11
          && (cpumodel.rP - 1) == cpumodel.rM
          && reset == 1'b1)
        begin
          $display("Detected forever loop, halting CPU.");
          $finish;
        end
      if (cpumodel.exec_state == 3'd0 && reset == 1'b1)
        begin
          $display("A = %x, B = %x, M = %x, P = %x",
                   cpumodel.rA, cpumodel.rB, cpumodel.rM, cpumodel.rP);
        end
    end

  tinycpu cpumodel
    (.clk(clk),
     .reset(reset)
    );

endmodule // tinycpu_test
