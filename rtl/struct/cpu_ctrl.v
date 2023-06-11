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
   localparam IDLE    = 3'd0;
   localparam FETCH   = 3'd1;
   localparam EXEC    = 3'd2;
   localparam MEMACC1 = 3'd3;
   localparam MEMACC2 = 3'd4;
   localparam MEMACC3 = 3'd5;
   
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
   output wire       mux_rB;
   output wire [1:0] mux_rM;
   output reg        den;
   output reg        cen;
   output reg        wen;
   output reg        oen;
   output wire [1:0] alu_ctrl;
   output wire       rP_inc;
   output wire       rP_load;
   output wire       addr_ctrl;
   output reg        rA_we;
   output wire       rB_we;
   output wire       rM_we;

   //--------------------------------------------------------------------
   // Internals
   //--------------------------------------------------------------------
   reg [3:0]         state;
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
                    state <= FETCH;
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
                         state <= MEMACC2;
                      end
                    else 
                      if (inst[7:4] == STM)
                        begin
                           state <= MEMACC1;
                        end
                 end

               MEMACC1 :
                 begin
                    state <= MEMACC2;
                 end
               MEMACC2 :
                 begin
                    if (inst[7:4] == STM)
                      begin
                         state <= MEMACC3;
                      end
                    else
                      begin
                         state <= IDLE;
                      end
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
   wire inst_we;
   
   assign inst_we = (~state[2]) & (~state[1]) & (state[0]);
   
   always@ (posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             inst <= 'b0;
          end
        else
          if (inst_we == 'b1)
            begin
               inst <= dq;  
            end
     end // always@ (posedge clk or negedge rst)

   //--------------------------------------------------------------------
   // rA MUX and we control
   //--------------------------------------------------------------------
   assign mux_rA[2] = state[2] | (state[1] & state[0]);
  
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
               rA_we  <= 'b0;
            end
          MEMACC2 :
            begin
               mux_rA <= 'd4;
               rA_we  <= 'b1;
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
   assign mux_rB = ((~state[2]) & state[1] & (~state[0])) & ((inst[7]) & (~inst[6]) & (~inst[5]) & (inst[4]));
   assign rB_we  = ((~state[2]) & state[1] & (~state[0])) & ((inst[7]) & (~inst[6]) & (~inst[5]));
   
   // always@ (*)
   //   begin
   //      if (state == EXEC)
   //        begin
   //           if (inst[7:4] == SWAB)
   //             begin
   //                mux_rB <= 1'b0;
   //                rB_we  <= 'b1;
   //             end
   //           else
   //             if (inst[7:4] == SWMB)
   //               begin
   //                  mux_rB <= 1'b1;
   //                  rB_we  <= 'b1;
   //               end
   //             else
   //               begin
   //                  mux_rB <= 1'b0;
   //                  rB_we  <= 'b0;
   //               end
   //        end // if (state == EXEC)
   //      else
   //        begin
   //           mux_rB <= 1'b0;
   //           rB_we  <= 'b0;
   //        end
   //   end

   //--------------------------------------------------------------------
   // rM MUX control
   //--------------------------------------------------------------------
   assign rM_we = ((~state[2]) & state[1] & (~state[0])) & ((inst[7]) & (~inst[6]) & (inst[4]));
   assign mux_rM[0] = ((~state[2]) & state[1] & (~state[0])) & ((inst[7]) & (~inst[6]) & (~inst[5]) & (inst[4]));
   assign mux_rM[1] = ((~state[2]) & state[1] & (~state[0])) & ((inst[7]) & (inst[6]));
   
   // always@ (*)
   //   begin
   //      if (state == EXEC)
   //        begin
   //           case (inst[7:4])
   //             CPAM :
   //               begin
   //                  mux_rM <= 'd0;
   //                  rM_we  <= 'b1;
   //               end
   //             SWMB :
   //               begin
   //                  mux_rM <= 'd1;
   //                  rM_we  <= 'b1;
   //               end
   //             JU   :
   //               begin
   //                  mux_rM <= 'd2;
   //                  rM_we  <= 'b0;
   //               end
   //             JE   :
   //               begin
   //                  mux_rM <= 'd2;
   //                  rM_we  <= 'b0;
   //               end
   //             JL   :
   //               begin
   //                  mux_rM <= 'd2;
   //                  rM_we  <= 'b0;
   //               end
   //             JG   :
   //               begin
   //                  mux_rM <= 'd2;
   //                  rM_we  <= 'b0;
   //               end
   //             default :
   //               begin
   //                  mux_rM <= 'd3;
   //                  rM_we  <= 'b0;
   //               end
   //           endcase
   //        end // if (state == EXEC)
   //      else
   //        begin
   //           mux_rM <= 'd3;
   //           rM_we <= 'b0;
   //        end
   //   end

   //--------------------------------------------------------------------
   // den control
   //--------------------------------------------------------------------
   wire den_fc ;
   wire den_sc ;

   assign den_fc = (~state[2]) & (state[1]) & (state[0]);
   assign den_sc = (state[2]) & (~state[1]) & (~state[0]) & ((~inst[7]) & (inst[6]) & (inst[5]) & (~inst[4]));
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             den <= 1'b0;
          end
        else
          begin
             den <= den_fc | den_sc;
          end
     end

   //--------------------------------------------------------------------
   // cen control
   //--------------------------------------------------------------------
   wire cen_fc ;
   wire cen_sc ;
   wire cen_tc ;

   assign cen_fc = (~state[2]) & (~state[1]) & (~state[0]);
   assign cen_sc = (~state[2]) & state[1] & (~state[0]) & ((~inst[7]) & (inst[6]) & (~inst[5]) & (inst[4]));
   assign cen_tc = (~state[2]) & (state[1]) & (state[0]);
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             cen <= 1'b1;
          end
        else
          begin
             cen <= ~(cen_fc | cen_sc | cen_tc);
          end
     end

   //--------------------------------------------------------------------
   // wen control
   //--------------------------------------------------------------------
   wire wen_fc;

   assign wen_fc = (~state[2]) & state[1] & state[0] & ((~inst[7]) & (inst[6]) & (inst[5]) & (~inst[4]));
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             wen <= 1'b1;
          end
        else
          begin
             wen <= ~wen_fc;
          end
     end

   //--------------------------------------------------------------------
   // oen control
   //--------------------------------------------------------------------
   wire oen_fc;
   wire oen_sc;

   assign oen_fc = (~state[2]) & (~state[1]) & (~state[0]);
   assign oen_sc = (~state[2]) & (state[1]) & (~state[0]) & ((~inst[7]) & (inst[6]) & (~inst[5]) & (inst[4]));
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             oen <= 1'b1;
          end
        else
          begin
             oen <= ~(oen_fc | oen_sc);
          end
     end

   //--------------------------------------------------------------------
   // alu control
   //--------------------------------------------------------------------
   // always@ (*)
   //   begin
   //      alu_ctrl <= inst[5:4];
   //   end
   assign alu_ctrl = inst[5:4]; 
   
   //--------------------------------------------------------------------
   // program counter increment control
   //--------------------------------------------------------------------
   assign rP_inc = (~state[2]) & (~state[1]) & (state[0]);
   
   //--------------------------------------------------------------------
   // program counter load from rM control
   //--------------------------------------------------------------------
   wire rpl_fc;
   wire rpl_sc;
   wire rpl_tc;
   wire rpl_fourth_case;
   
   assign rpl_fc = ((inst[7]) & (inst[6]) & (~inst[5]) & (~inst[4]));
   assign rpl_sc = ((inst[7]) & (inst[6]) & (~inst[5]) & (inst[4])) & ((~cmp[1]) & (~cmp[0])) ;
   assign rpl_tc = ((inst[7]) & (inst[6]) & (inst[5]) & (~inst[4])) & ((~cmp[1]) & cmp[0]) ;
   assign rpl_fourth_case = ((inst[7]) & (inst[6]) & (inst[5]) & (inst[4])) & (cmp[1] & (~cmp[0])) ;
   assign rP_load = ((~state[2]) & state[1] & (~state[0])) & (rpl_fc | rpl_sc | rpl_tc | rpl_fourth_case);
   
   //--------------------------------------------------------------------
   // Address control signal for MUX
   //--------------------------------------------------------------------
   wire ac_fc;
   wire ac_sc;
   
   assign ac_fc =  ((~state[2]) & state[1] & (~state[0])) & ((~inst[7]) & (inst[6]) & (~inst[5]) & (inst[4]));
   assign ac_sc =  ((~state[2]) & (state[1]) & (state[0])) & ((~inst[7]) & (inst[6]) & (inst[5]) & (~inst[4]));
   assign addr_ctrl = ac_fc || ac_sc;
   

endmodule

