module tinycpu
  (input       clk,
   input       reset
  );

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

  //----------------------------------------------------------------------
  // FSM States
  //----------------------------------------------------------------------
  localparam     IDLE    = 3'd0;
  localparam     FETCH   = 3'd1;
  localparam     EXEC    = 3'd2;
  localparam     MEMACC  = 3'd3;

  //----------------------------------------------------------------------
  // CPU registers
  //----------------------------------------------------------------------
  reg [7:0]    rA;
  reg [7:0]    rB;
  reg [7:0]    rM;
  reg [7:0]    rP;

  //----------------------------------------------------------------------
  // Other regs and wires
  //----------------------------------------------------------------------
  reg          den;
  reg          cen;
  reg          wen;
  reg          oen;
  reg [7:0]    addr;
  reg [2:0]    exec_state;
  reg [7:0]    instr;

  // Memory data bus - has tristate control
  wire [7:0]   dq = den ? rA : 8'hZZ;

  //----------------------------------------------------------------------
  // Control FSM and Instruction decode and execute (all in one)
  //----------------------------------------------------------------------
  always @(posedge clk or negedge reset)
    if (reset == 1'b0)
      begin
        rA         <= 8'h00;
        rB         <= 8'h00;
        rM         <= 8'h00;
        rP         <= 8'h00;

        cen        <= 1'b1;
        oen        <= 1'b1;
        wen        <= 1'b1;
        den        <= 1'b0;
        instr      <= 8'h00;
        addr       <= 8'h00;

        exec_state <= IDLE;
      end

    else
      begin
        case (exec_state)
          IDLE:
            begin
              cen        <= 1'b0;
              oen        <= 1'b0;
              wen        <= 1'b1;
              addr       <= rP;
              den        <= 1'b0;
              exec_state <= FETCH;
            end

          FETCH:
            begin
              cen        <= 1'b1;
              oen        <= 1'b1;
              wen        <= 1'b1;
              addr       <= rP;
              den        <= 1'b0;
              instr      <= dq;
              rP         <= rP + 1'b1;
              exec_state <= EXEC;
            end

          EXEC:
            begin
              addr <= rP;
              exec_state <= IDLE;

              case (instr[7:4])
                //----------------------------------------------------------
                // Arithmetic
                //----------------------------------------------------------
                AND:
                  begin
                    rA <= rA & rB;
                  end

                OR:
                  begin
                    rA <= rA | rB;
                  end

                INV:
                  begin
                    rA <= ~rA;
                  end

                ADD:
                  begin
                    rA <= rA + rB;
                  end

                //----------------------------------------------------------
                // Data Movement from and to memory
                //----------------------------------------------------------
                LDI:
                  begin
                    rA <= {rA[3:0], instr[3:0]};
                  end

                LDM:
                  begin
                    cen        <= 1'b0;
                    oen        <= 1'b0;
                    wen        <= 1'b1;
                    den        <= 1'b0;
                    addr       <= rM;
                    exec_state <= MEMACC;
                  end

                STM:
                  begin
                    cen        <= 1'b0;
                    oen        <= 1'b1;
                    wen        <= 1'b0;
                    den        <= 1'b1;
                    addr       <= rM;
                    exec_state <= MEMACC;
                  end

                //----------------------------------------------------------
                // Data Movement within registers
                //----------------------------------------------------------
                SWAB:
                  begin
                    rA <= rB;
                    rB <= rA;
                  end

                SWMB:
                  begin
                    rB <= rM;
                    rM <= rB;
                  end

                CPPA:
                  begin
                    rA <= rP;
                  end

                CPAM:
                  begin
                    rM <= rA;
                  end

                //----------------------------------------------------------
                // Branch
                //----------------------------------------------------------
                JU:  // Unconditional Jump
                  begin
                    // rM <= rP;
                    rP <= rM;
                  end

                JE:  // Jump on equal flag
                  begin
                    if (rA == rB)
                      begin
                        // rM <= rP;
                        rP <= rM;
                      end
                  end

                JL:  // Jump on less than flag
                  begin
                    if (rA < rB)
                      begin
                        // rM <= rP;
                        rP <= rM;
                      end
                  end

                JG:  // Jump on greater than flag
                  begin
                    if (rA > rB)
                      begin
                        // rM <= rP;
                        rP <= rM;
                      end
                  end

              endcase // case (instr)

            end // case: EXEC

          MEMACC:
            begin
              if (den == 1'b0)
                begin
                  rA <= dq;
                end
              cen        <= 1'b1;
              oen        <= 1'b1;
              wen        <= 1'b1;
              addr       <= rP;
              den        <= 1'b0;
              exec_state <= IDLE;
            end

        endcase // case (exec_state)

      end // else: !if(!reset)

  //----------------------------------------------------------------------
  // SRAM
  //----------------------------------------------------------------------
  sram sram
    (.addr(addr),
     .cen(cen),
     .wen(wen),
     .oen(oen),
     .dq(dq)
     );


endmodule
