//--------------------------------------------------------------------
// File: cpu_ctrl.v
// Name: Omkar Girish Kamath
// Date: 17th May 2023
// Description: Provides all the control signal for CPU function such
// as for MUXes, write enable for registers, ALU etc.
//
//--------------------------------------------------------------------

module cpu_ctrl (
                 dq,     // input from sram_ctrl
                 rst,
                 clk,
                 cmp,      // compare result sig in
                 mux_rA,   // control sig for register MUXes
                 rA_we,
                 mux_rB,
                 rB_we,
                 mux_rM,
                 rM_we,
                 den,      // control sig for SRAM ctrl
                 cen,
                 wen,
                 oen,
                 alu_ctrl, // control sig for ALU
                 rP_inc,   // control sig for rP
                 rP_load,
                 addr_ctrl// address control signal to SRAM ctrl
                 );

   //----------------------------------------------------------------------
   // Instruction Set
   //----------------------------------------------------------------------
   //Arithmetic and Logic
   localparam     AND   = 4'h0;            // A = A & B
   localparam     OR    = 4'h1;            // A = A | B
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

   //--------------------------------------------------------------------
   // Processor States
   //--------------------------------------------------------------------
   localparam IDLE    = 6'b100000;
   localparam FETCH   = 6'b010000;
   localparam EXEC    = 6'b001000;
   localparam MEMACC1 = 6'b000100;
   localparam MEMACC2 = 6'b000010;
   localparam MEMACC3 = 6'b000001;
   
   // Compare Results
   localparam EQ = 2'b00;
   localparam LT = 2'b01;
   localparam GT = 2'b10;

   //--------------------------------------------------------------------
   // Inputs
   //--------------------------------------------------------------------
   input wire        clk;
   input wire        rst;
   input wire [7:0]  dq ;
   input wire [1:0]  cmp;

   //--------------------------------------------------------------------
   // Outputs
   //--------------------------------------------------------------------
   output reg [2:0]  mux_rA;
   output reg        mux_rB;
   output reg [1:0]  mux_rM;
   output reg        den;
   output reg        cen;
   output reg        wen;
   output reg        oen;
   output reg [1:0]  alu_ctrl;
   output reg        rP_inc;
   output reg        rP_load;
   output reg        addr_ctrl;
   output reg        rA_we;
   output reg        rB_we;
   output reg        rM_we;

   //--------------------------------------------------------------------
   // Internals
   //--------------------------------------------------------------------
   reg [5:0]         state;
   reg [7:0]         inst;
   
   //--------------------------------------------------------------------
   // Processor State Machine
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             state <= IDLE;
          end
        else
          begin
             case (state)
               IDLE :
                 begin
                    state <= FETCH ;
                 end

               FETCH :
                 begin
                    state <= EXEC ;
                 end

               EXEC :
                 begin
                    state <= IDLE;
                    if (inst[7:4] == LDM)
                      begin
                         state <= MEMACC1;
                      end
                    else 
                      if (inst[7:4] == STM)
                        begin
                           state <= MEMACC1;
                        end
                 end

               MEMACC1 :
                 begin
                    if (inst[7:4] == STM)
                      begin
                         state <= MEMACC2;
                      end
                    else
                      begin
                         state <= IDLE;
                      end
                 end
               MEMACC2 :
                 begin
                    state <= MEMACC3;
                 end
               MEMACC3 :
                 begin
                    state <= IDLE ;
                 end

               default :
                 begin
                    state <= IDLE ;
                 end
             endcase
          end
     end

   //--------------------------------------------------------------------
   // Instruction Register
   //--------------------------------------------------------------------
   always@ (posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             inst <= 'b0;
          end
        else
          begin
             if (state == FETCH)
               begin
                  inst <= dq;
               end
          end
     end // always@ (posedge clk or negedge rst)

   //--------------------------------------------------------------------
   // rA MUX and we control
   //--------------------------------------------------------------------
   always@ (*)
     begin
        case (state)
          EXEC :
            begin
               case (inst[7:4])
                 LDI :
                   begin
                      mux_rA <= 'd0;
                      rA_we  <= 'b1;
                   end
                 AND :
                   begin
                      mux_rA <= 'd1;
                      rA_we  <= 'b1;
                   end
                 OR  :
                   begin
                      mux_rA <= 'd1;
                      rA_we  <= 'b1;
                   end
                 INV :
                   begin
                      mux_rA <= 'd1;
                      rA_we  <= 'b1;
                   end
                 ADD :
                   begin
                      mux_rA <= 'd1;
                      rA_we  <= 'b1;
                   end
                 SWAB :
                   begin
                      mux_rA <= 'd2;
                      rA_we  <= 'b1;
                   end
                 CPPA :
                   begin
                      mux_rA <= 'd3;
                      rA_we  <= 'b1;
                   end
                 default :
                   begin
                      mux_rA <= 'd0;
                      rA_we  <= 'b0;
                   end
               endcase
            end // case: EXEC
          MEMACC1 :
            begin
               mux_rA <= 'd4;
               if (inst[7:4] == LDM)
                 begin
                    rA_we  <= 'b1;
                 end
               else
                 begin
                    rA_we <= 'b0;
                 end
            end
          MEMACC2 :
            begin
               mux_rA <= 'd4;
               rA_we  <= 'b0;
            end
          MEMACC3 :
            begin
               mux_rA <= 'd4;
               rA_we  <= 'b0;
            end
          default:
            begin
               mux_rA <= 'b0;
               rA_we  <= 'b0;
            end
        endcase
     end

   //--------------------------------------------------------------------
   // rB MUX and we control
   //--------------------------------------------------------------------
   always@ (*)
     begin

        if (state == EXEC)
          begin
             if (inst[7:4] == SWAB)
               begin
                  mux_rB <= 1'b0;
                  rB_we  <= 'b1;
               end
             else
               if (inst[7:4] == SWMB)
                 begin
                    mux_rB <= 1'b1;
                    rB_we  <= 'b1;
                 end
          end // if (state == EXEC)
        else
          begin
             mux_rB <= 1'b0;
             rB_we  <= 'b0;
          end
     end

   //--------------------------------------------------------------------
   // rM MUX control
   //--------------------------------------------------------------------
   always@ (*)
     begin
        if (state == EXEC)
          begin
             case (inst[7:4])
               CPAM :
                 begin
                    mux_rM <= 'd0;
                    rM_we  <= 'b1;
                 end
               SWMB :
                 begin
                    mux_rM <= 'd1;
                    rM_we  <= 'b1;
                 end
               JU   :
                 begin
                    mux_rM <= 'd2;
                    rM_we  <= 'b0;
                 end
               JE   :
                 begin
                    mux_rM <= 'd2;
                    rM_we  <= 'b0;
                 end
               JL   :
                 begin
                    mux_rM <= 'd2;
                    rM_we  <= 'b0;
                 end
               JG   :
                 begin
                    mux_rM <= 'd2;
                    rM_we  <= 'b0;
                 end
               default :
                 begin
                    mux_rM <= 'd0;
                    rM_we  <= 'b0;
                 end
             endcase
          end // if (state == EXEC)
        else
          begin
             mux_rM <= 'd0;
             rM_we <= 'b0;
          end
     end

   //--------------------------------------------------------------------
   // den control
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             den <= 1'b0;
          end
        else
          begin
             if (((state == MEMACC1) || (state == MEMACC2)) && (inst[7:4] == STM))
               begin
                  den <= 'b1;
               end
             else
               begin
                  den <= 'b0;
               end
          end
     end

   //--------------------------------------------------------------------
   // cen control
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             cen <= 1'b1;
          end
        else
          begin
             if ((state == IDLE) || ((state == EXEC) && (inst[7:4] == LDM)) || (state == MEMACC1))
               begin
                  cen <= 'b0;
               end
             else
               begin
                  cen <= 'b1;
               end
          end
     end

   //--------------------------------------------------------------------
   // wen control
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             wen <= 1'b1;
          end
        else
          begin
             if ((state == MEMACC1) && ((inst[7:4] == STM)))
               begin
                  wen <= 'b0;
               end
             else
               begin
                  wen <= 'b1;
               end
          end
     end


   //--------------------------------------------------------------------
   // oen control
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             oen <= 1'b1;
          end
        else
          begin
             if ((state == IDLE) || (((state == EXEC) || (state == MEMACC1)) && (inst[7:4] == LDM)))
               begin
                  oen <= 'b0;
               end
             else
               begin
                  oen <= 'b1;
               end
          end
     end

   //--------------------------------------------------------------------
   // alu control
   //--------------------------------------------------------------------
   always@ (*)
     begin
        alu_ctrl <= inst[5:4];
     end

   //--------------------------------------------------------------------
   // program counter increment control
   //--------------------------------------------------------------------
   always@ (*)
     begin
        if (state == FETCH)
          begin
             rP_inc <= 'b1;
          end
        else
          begin
             rP_inc <= 'b0;
          end
     end

   //--------------------------------------------------------------------
   // program counter load from rM control
   //--------------------------------------------------------------------
   always@ (*)
     begin
        if (state == EXEC && ((inst[7:4] == JU))||((inst[7:4] == JE)&&(cmp == EQ))||((inst[7:4] == JL)&&(cmp == LT))||((inst[7:4] == JG)&&(cmp == GT)))
          begin
             rP_load <= 'b1;
          end
        else
          begin
             rP_load <= 'b0;
          end
     end // always@ (*)

   //--------------------------------------------------------------------
   // Address control signal for MUX
   //--------------------------------------------------------------------

   always@ (*)
     begin
        if (((state == EXEC) && (inst[7:4] == LDM || inst[7:4] == STM)) || ((inst[7:4] == STM) && (state == MEMACC1)) || (state == MEMACC2) || state == MEMACC3)
          begin
             addr_ctrl <= 'b1;
          end
        else
          begin
             addr_ctrl <= 'b0;
          end
     end

   // assign addr_ctrl = (state ^ EXEC) & (inst[7:4] ^ LDM)

endmodule

