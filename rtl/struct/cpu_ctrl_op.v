//--------------------------------------------------------------------
// File: cpu_ctrl_op.v
// Name: Omkar Girish Kamath
// Date: 16th June 2023
// Description: Provides all the control signal for CPU function such
// as for MUXes, write enable for registers, ALU etc. Optimised 
// version.
//--------------------------------------------------------------------

   module cpu_ctrl_op (
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
   localparam     AND   = 4'h0;            // A = A && B
   localparam     OR    = 4'h1;            // A = A || B
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
   output wire [2:0] mux_rA;
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
   output wire       rA_we;
   output wire       rB_we;
   output wire       rM_we;

   //--------------------------------------------------------------------
   // Internals
   //--------------------------------------------------------------------
   reg [5:0]         state;
   reg [7:0]         inst;
   wire [2:0]        in;
   wire              nota;
   wire              den_fc ;
   wire              inst_we;
   wire              cen_fc ;
   wire              cen_sc ;
   wire              cen_tc ;
   wire              wen_fc;
   wire              ac_fc;
   wire              ac_sc;
   wire              rpl_fc;
   wire              rpl_sc;
   wire              rpl_tc;
   wire              rpl_fourth_case;
   wire              oen_fc;
   wire              oen_sc;

   //--------------------------------------------------------------------
   // Redundancy Eliminator
   //--------------------------------------------------------------------
   wire              notfivefour;
   assign notfivefour = (~inst[5]) && (inst[4]);
   
   wire              sevsix;
   assign sevsix = (inst[7]) && (inst[6]);
   
   wire              sevnotsix;
   assign sevnotsix = (inst[7]) && (~inst[6]);

   wire              notsevnotsix;
   assign notsevnotsix = (~inst[7]) && (~inst[6]);
   
   wire              stm;
   assign stm = ((~inst[7]) && (inst[6]) && (inst[5]) && (~inst[4]));
   
   wire              ldm;
   assign ldm = ((~inst[7]) && (inst[6]) && notfivefour);
   
   wire              swmb;
   assign swmb = sevnotsix && notfivefour;
      
   //--------------------------------------------------------------------
   // Instruction Indicator
   //--------------------------------------------------------------------
   assign nota = ~(ldm || stm);
   assign in = {nota,ldm,stm};
   
   //--------------------------------------------------------------------
   // Processor State Machine
   //--------------------------------------------------------------------
   always @(posedge clk or negedge rst)
     begin
        if (rst == 1'b0)
          begin
             state <= 6'b100000;
          end
        else
          begin
             state[0] <= state[1];
             state[1] <= state[2] && in[0];
             state[2] <= state[3] && (in[0] || in[1]);
             state[3] <= state[4];
             state[4] <= state[5];
             state[5] <= (state[3] && in[2]) || (state[2] && in[1]) || 
                         (state[0]);
          end
     end // always @ (posedge clk or negedge rst)

   
   //--------------------------------------------------------------------
   // Instruction Register
   //--------------------------------------------------------------------
   assign inst_we = (state[4]);
   
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
   assign rA_we = (state[3]) && 
                  ((~inst[7]) && (~inst[5]) && 
                   (~inst[4]) || notsevnotsix || 
                   (~inst[6]) && (~inst[4])) ||
                  (state[2] && ldm);
   assign mux_rA[1] = (state[3]) && sevnotsix && (~inst[4]) ;
   assign mux_rA[2] = state[0] || state[1] || state[2];
   assign mux_rA[0] = (state[3]) && ((~inst[6]) && (inst[5]) && 
                                     (~inst[4]) || notsevnotsix);

   //--------------------------------------------------------------------
   // rB MUX and we control
   //--------------------------------------------------------------------
   assign mux_rB = ((state[3])) && swmb;
   assign rB_we  = ((state[3])) && (sevnotsix && (~inst[5]));

   //--------------------------------------------------------------------
   // rM MUX control
   //--------------------------------------------------------------------
   assign rM_we = ((state[3])) && (sevnotsix && (inst[4]));
   assign mux_rM[0] = ((state[3])) && swmb;
   assign mux_rM[1] = ((state[3])) && sevsix;

   //--------------------------------------------------------------------
   // den control
   //--------------------------------------------------------------------
   assign den_fc = ((state[2]) || (state[1])) && stm;
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             den <= 1'b0;
          end
        else
          begin
             den <= den_fc;
          end
     end

   //--------------------------------------------------------------------
   // cen control
   //--------------------------------------------------------------------
   assign cen_fc = (state[5]);
   assign cen_sc = (state[3]) && ldm;
   assign cen_tc = (state[2]);
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             cen <= 1'b1;
          end
        else
          begin
             cen <= ~(cen_fc || cen_sc || cen_tc);
          end
     end

   //--------------------------------------------------------------------
   // wen control
   //--------------------------------------------------------------------
   assign wen_fc = (state[2]) && stm;
   
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
   assign oen_fc = (state[5]);
   assign oen_sc = (state[2] || state[3]) && ldm;
   
   always @(posedge clk or negedge rst)
     begin
        if (rst == 'b0)
          begin
             oen <= 1'b1;
          end
        else
          begin
             oen <= ~(oen_fc || oen_sc);
          end
     end

   //--------------------------------------------------------------------
   // alu control
   //--------------------------------------------------------------------
   assign alu_ctrl = inst[5:4]; 
   
   //--------------------------------------------------------------------
   // program counter increment control
   //--------------------------------------------------------------------
   assign rP_inc = (state[4]);
   
   //--------------------------------------------------------------------
   // program counter load from rM control
   //--------------------------------------------------------------------
   assign rpl_fc = (sevsix && (~inst[5]) && (~inst[4]));
   assign rpl_sc = (sevsix && notfivefour) && 
                   ((~cmp[1]) && (~cmp[0])) ;
   assign rpl_tc = (sevsix && (inst[5]) && (~inst[4])) && 
                   ((~cmp[1]) && cmp[0]) ;
   assign rpl_fourth_case = (sevsix && (inst[5]) && (inst[4])) && 
                            (cmp[1] && (~cmp[0])) ;
   assign rP_load = ((state[3])) && 
                    (rpl_fc || rpl_sc || rpl_tc || rpl_fourth_case);
   
   //--------------------------------------------------------------------
   // Address control signal for MUX
   //--------------------------------------------------------------------   
   assign ac_fc =  state[3] && (ldm || stm);
   assign ac_sc =  state[2] && stm;
   assign addr_ctrl = ac_fc || ac_sc || state[1] || state[0];
   
endmodule

