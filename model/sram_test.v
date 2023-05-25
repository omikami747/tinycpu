module sram_test;
  
  reg [7:0]   addr;
  reg         cen;
  reg         wen;
  reg         oen;
  wire [7:0]  dq;
  reg [7:0]   wr_data;

  assign dq = oen ? wr_data : 8'hZZ;

  initial
    begin
      $dumpvars;
      
      addr     <= 8'hAB;
      cen      <= 1'b1;
      wen      <= 1'b1;
      oen      <= 1'b1;
      wr_data  <= 8'hZZ;
      #100;

      //----------------------------------------------------------------------
      // WE initiated, WE terminated write
      cen      <= 1'b0;
      #10;
      wr_data  <= 8'hDE;
      wen      <= 1'b0;
      #10;
      wen      <= 1'b1;
      #10;
      wr_data  <= 8'hZZ;
      cen      <= 1'b1;
      #20;

      // OE initiated, OE terminated read
      cen      <= 1'b0;
      #10;
      oen      <= 1'b0;
      #10;
      oen      <= 1'b1;
      #10;
      cen      <= 1'b1;
      #100;

      //----------------------------------------------------------------------
      // CE initiated, WE terminated write
      addr     <= 8'h38;
      
      wen      <= 1'b0;
      #10;
      wr_data  <= 8'hAA;
      cen      <= 1'b0;
      #10;
      wen      <= 1'b1;
      #10;
      wr_data  <= 8'hZZ;
      cen      <= 1'b1;
      #20;

      // OE initiated, OE terminated read
      cen      <= 1'b0;
      #10;
      oen      <= 1'b0;
      #10;
      oen      <= 1'b1;
      #10;
      cen      <= 1'b1;
      #100;
      
      //----------------------------------------------------------------------
      // WE initiated, CE terminated write
      addr     <= 8'h55;

      cen      <= 1'b0;
      #10;
      wr_data  <= 8'hFF;
      wen      <= 1'b0;
      #10;
      cen      <= 1'b1;
      #10;
      wr_data  <= 8'hZZ;
      wen      <= 1'b1;
      #20;

      // OE initiated, OE terminated read
      cen      <= 1'b0;
      #10;
      oen      <= 1'b0;
      #10;
      oen      <= 1'b1;
      #10;
      cen      <= 1'b1;
      #100;

      //----------------------------------------------------------------------
      // CE initiated, CE terminated write
      addr     <= 8'h77;

      wen      <= 1'b0;
      #10;
      wr_data  <= 8'hDD;
      cen      <= 1'b0;
      #10;
      cen      <= 1'b1;
      #10;
      wr_data  <= 8'hZZ;
      wen      <= 1'b1;
      #20;

      // OE initiated, OE terminated read
      cen      <= 1'b0;
      #10;
      oen      <= 1'b0;
      #10;
      oen      <= 1'b1;
      #10;
      cen      <= 1'b1;
      #100;

      
      #100;
      $finish;
      
    end

  sram sram
    (.addr(addr),
     .cen(cen),
     .wen(wen),
     .oen(oen),
     .dq(dq)
     );


endmodule // sram_test
