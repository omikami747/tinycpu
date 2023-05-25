module sram
  (input [7:0]   addr,
   input         cen,
   input         wen,
   input         oen,
   inout [7:0]   dq
  );

`ifdef DEBUG
  localparam DEBUG_ON = 1;
`else
  localparam DEBUG_ON = 0;
`endif

  localparam TOOLCHAIN = 0;
  
  //----------------------------------------------------------------------
  // Instruction Set
  //----------------------------------------------------------------------
  //Arithmetic and Logic
  localparam     AND   = 4'h0;            // A = A & B
  localparam     OR    = 4'h1;            // A = A |  B
  localparam     INV   = 4'h2;            // A = ~A
  localparam     ADD   = 4'h3;            // A = A + B

  // Data Movement from and to memory
  localparam     LDI   = 4'h4;            // A = {A[3:0], instr[3:0]}
  localparam     LDM   = 4'h5;            // A = mem(M)
  localparam     STM   = 4'h6;            // mem(M) = A

  // Data Movement within registers
  localparam     SWAB  = 4'h8;            // A <-> B
  localparam     SWMB  = 4'h9;            // M <-> B
  localparam     CPPA  = 4'hA;            // A <-- P
  localparam     CPAM  = 4'hB;            // M <-- A

  // Jumps and branching
  localparam     JU    = 4'hC;            // Always   P <-> M
  localparam     JE    = 4'hD;            // A == B ? P <-> M
  localparam     JL    = 4'hE;            // A < B  ? P <-> M
  localparam     JG    = 4'hF;            // A > B  ? P <-> M

  reg  [7:0]   addr_reg;
  reg  [7:0]   sram [0:255];
  reg          hizen;
  wire [7:0]   q;
  
  assign q  = sram[addr];
  assign dq = hizen ? q : 8'hZZ;
  
  initial
    begin
      if (TOOLCHAIN)
        begin
          $readmemh("program.mem", sram);
        end
      else
        begin
          sram[  0] = {LDI,  4'h3};  // LDI 3
          sram[  1] = {LDI,  4'h4};  // LDI 4
          sram[  2] = {SWAB, 4'h0};  // SWAB
          sram[  3] = {LDI,  4'h1};  // LDI 1
          sram[  4] = {LDI,  4'h2};  // LDI 2
          sram[  5] = {ADD,  4'h0};  // ADD
          sram[  6] = {SWAB, 4'h0};  // SWAB
          sram[  7] = {LDI,  4'h7};  // LDI 7
          sram[  8] = {LDI,  4'hF};  // LDI F
          sram[  9] = {CPAM, 4'h0};  // CPAM
          sram[ 10] = {SWAB, 4'h0};  // SWAB
          sram[ 11] = {STM,  4'h0};  // STM  (M[7F] = 46)
          sram[ 12] = {LDI,  4'h0};  // LDI 0
          sram[ 13] = {LDI,  4'h0};  // LDI 0
          sram[ 14] = {LDM,  4'h0};  // LDM  (A = M[7F] = 46)

          sram[ 15] = {LDI,  4'h1};  // LDI 1
          sram[ 16] = {LDI,  4'h2};  // LDI 2 (12 hex is 18 decimal)
          sram[ 17] = {CPAM, 4'h0};  // CPAM
          sram[ 18] = {JU,   4'h0};  // JU (to this address - 0x12 = 0d18)

          // This is a forever loop or halt
        end      
    end // initial begin
  
  always // @(cen or oen or wen)
    begin
      hizen <= 1'b0;
      wait ((cen == 1'b0) || (wen == 1'b0));

      if (cen == 1'b1)     // CE initiated cycle
        begin
          wait(cen == 1'b0);
          addr_reg <= addr;  // Flop address on falling edge of CE
          
          if (DEBUG_ON)
            begin
              $display("At time %0t: CE Initiated Write cycle", $stime);
            end

          wait ((cen == 1'b1) || (wen == 1'b1));

          if (DEBUG_ON)
            begin
              if (wen == 1'b1)
                begin
                  $display("At time %0t: WE Terminated Write Cycle, mem[%x] = %x", $stime, addr_reg, dq);
                end
              else
                begin
                  $display("At time %0t: CE Terminated Write Cycle, mem[%x] = %x", $stime, addr_reg, dq);
                end
            end

          sram[addr_reg] = dq;
          wait ((cen == 1'b1) && (wen == 1'b1));
        end
      
      else                 // WE initiated cycle
        begin
          wait ((wen == 1'b0) || (oen == 1'b0));

          if (wen == 1'b0) // Write cycle
            begin
              addr_reg <= addr;  // Flop address on falling edge of CE

              if (DEBUG_ON)
                begin
                  $display("At time %0t: WE Initiated Write cycle", $stime);
                end
              
              wait ((cen == 1'b1) || (wen == 1'b1));

              if (DEBUG_ON)
                begin
                  if (wen == 1'b1)
                    begin
                      $display("At time %0t: WE Terminated Write Cycle, mem[%x] = %x", $stime, addr_reg, dq);
                    end
                  else
                    begin
                      $display("At time %0t: CE Terminated Write Cycle, mem[%x] = %x", $stime, addr_reg, dq);
                    end
                end

              sram[addr_reg] = dq;
              wait ((cen == 1'b1) && (wen == 1'b1));
            end // if (wen == 1'b0)
          
          else
            begin
              wait (oen == 1'b0);
              hizen <= 1'b1;
              if (DEBUG_ON)
                begin
                  $display("At time %0t: READ mem[%x] = %x", $stime, addr, q);
                end
              wait ((oen == 1'b1) || (cen == 1'b1));
              hizen <= 1'b0;
              wait ((oen == 1'b1) && (cen == 1'b1));
            end // else: !if(wen == 1'b0)
        end // else: !if(wen == 1'b0)
    end // always begin

endmodule // sram
