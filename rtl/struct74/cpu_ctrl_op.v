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

   // //--------------------------------------------------------------------
   // // Processor States
   // //--------------------------------------------------------------------
   // localparam IDLE    = 6'b100000;
   // localparam FETCH   = 6'b010000;
   // localparam EXEC    = 6'b001000;
   // localparam MEMACC1 = 6'b000100;
   // localparam MEMACC2 = 6'b000010;
   // localparam MEMACC3 = 6'b000001;
   
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
   output wire        den;
   output wire        cen;
   output wire        wen;
   output wire        oen;
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
   wire [5:0]        state;  // kept only for tinycpu_test.v purpose
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
   // Inverted Wires
   //--------------------------------------------------------------------
   wire              _inst[7:4];
   wire              _cen;
   wire              cen_fc_sc;
   wire              cen_in;
   
   assign cen_fc = (state5_out);
   assign cen_tc = (state2_out);
   
   hex_inv inv1(
                .pin1(inst[4]),
                .pin2(_inst[4]),
                .pin3(inst[5]),
                .pin4(_inst[5]),
                .pin5(inst[6]),
                .pin6(_inst[6]),
                .pin7(),
                .pin8(_inst[7]),
                .pin9(inst[7]),
                .pin10(inst_we),
                .pin11(state4_out),
                .pin12(cen_in),
                .pin13(_cen),
                .pin14()
                );
   
   //--------------------------------------------------------------------
   // Redundancy Eliminator
   //--------------------------------------------------------------------
   wire              sevsix;
   wire              sevnotsix;
   wire              notsevnotsix;
   wire              notfivefour;
   wire              stm_int1; 
   wire              stm_int2;
   wire              ldm;
   wire              swmb;
   wire              __inst6inst4;        //  both of these are from rA part
   wire              __inst7inst5;   //  , they are declared here for NOR.
   quadand and1 (
                 .pin1(inst[6]),
                 .pin2(inst[7]),
                 .pin3(sevsix),
                 .pin4(inst[7]),
                 .pin5(_inst[6]),
                 .pin6(sevnotsix),
                 .pin7(),
                 .pin8(stm_int1),
                 .pin9(inst[6]),
                 .pin10(_inst[7]),
                 .pin11(stm_int2),
                 .pin12(inst[5]),
                 .pin13(_inst[4]),
                 .pin14()
                 );
   quadand and2 (
                 .pin1(stm_int1),
                 .pin2(stm_int2),
                 .pin3(stm),
                 .pin4(notfivefour),
                 .pin5(sevnotsix),
                 .pin6(swmb),
                 .pin7(),
                 .pin8(ldm),
                 .pin9(stm_int1),
                 .pin10(notfivefour),
                 .pin11(notfivefour),
                 .pin12(_inst[5]),
                 .pin13(inst[4]),
                 .pin14()
                 );
   quadnor nor1 (
                 .pin1(inst[6]),
                 .pin2(inst[7]),
                 .pin3(notsevnotsix),
                 .pin4(ldm),
                 .pin5(stm),
                 .pin6(nota),
                 .pin7(),
                 .pin8(__inst7inst5),
                 .pin9(inst[7]),
                 .pin10(inst[5]),
                 .pin11(__inst6inst4),
                 .pin12(inst[6]),
                 .pin13(inst[4]),
                 .pin14()
                 );
   
   //--------------------------------------------------------------------
   // Instruction Indicator
   //--------------------------------------------------------------------
   // assign nota = ~(ldm || stm);
   assign in = {nota,ldm,stm};

   
   //--------------------------------------------------------------------
   // Dual DFF register modules
   //--------------------------------------------------------------------
   wire              state0_out;
   wire              state1_out;
   wire              state2_out;
   wire              state3_out;
   wire              state4_out;
   wire              state5_out;
   wire              state0_in;
   wire              state1_in;
   wire              state2_in;
   wire              state3_in;
   wire              state4_in;
   wire              state5_in;
   wire              state5_in_1;
   wire              state5_in_2;
   wire              state5_in_3;
   wire              in_2;
   wire              state12_out;  // equals state1_out | state2_out
   
   assign state0_in = state1_out;
   assign state3_in = state4_out;
   assign state4_in = state5_out;
   
   dualdff pair1 (
                  .pin1(rst),
                  .pin2(state0_in),
                  .pin3(clk),
                  .pin4(),
                  .pin5(state0_out),
                  .pin6(),
                  .pin7(),
                  .pin8(),
                  .pin9(state1_out),
                  .pin10(),
                  .pin11(clk),
                  .pin12(state1_in),
                  .pin13(rst),
                  .pin14()
                  );
    dualdff pair2 (
                  .pin1(rst),
                  .pin2(state2_in),
                  .pin3(clk),
                  .pin4(),
                  .pin5(state2_out),
                  .pin6(),
                  .pin7(),
                  .pin8(),
                  .pin9(state3_out),
                  .pin10(),
                  .pin11(clk),
                  .pin12(state3_in),
                  .pin13(rst),
                  .pin14()
                  );
    dualdff pair3 (
                  .pin1(rst),
                  .pin2(state4_in),
                  .pin3(clk),
                  .pin4(),
                  .pin5(state4_out),
                  .pin6(),
                  .pin7(),
                  .pin8(),
                  .pin9(state5_out),
                  .pin10(rst),
                  .pin11(clk),
                  .pin12(state5_in),
                  .pin13(),
                  .pin14()
                  );
   quadand and3 (
                 .pin1(in[0]),
                 .pin2(state2_out),
                 .pin3(state1_in),
                 .pin4(in_2),
                 .pin5(state3_out),
                 .pin6(state2_in),
                 .pin7(),
                 .pin8(state5_in_1),
                 .pin9(state3_out),
                 .pin10(in[2]),
                 .pin11(state5_in_2),
                 .pin12(state2_out),
                 .pin13(in[1]),
                 .pin14()
                 );
   quador or1 (
               .pin1(in[0]),
               .pin2(in[1]),
               .pin3(in_2),
               .pin4(state5_in_1),
               .pin5(state5_in_2),
               .pin6(state5_in_3),
               .pin7(),
               .pin8(state5_in),
               .pin9(state5_in_3),
               .pin10(state0_out),
               .pin11(state12_out),
               .pin12(state1_out),
               .pin13(state2_out),
               .pin14()
               );
   
   assign state = {state5_out,state4_out,state3_out,state2_out,state1_out,state0_out};
   
   //--------------------------------------------------------------------
   // Instruction Register
   //--------------------------------------------------------------------
   // assign inst_we = ~(state4_out);

   //--------------------------------------------------------------------
   // 8bit register modules
   //--------------------------------------------------------------------
   wire [7:0]        inst;
   
   reg8bit reg1 (
                 .pin1(inst_we),
                 .pin2(inst[7]),
                 .pin3(dq[7]),
                 .pin4(dq[6]),
                 .pin5(inst[6]),
                 .pin6(inst[5]),
                 .pin7(dq[5]),
                 .pin8(dq[4]),
                 .pin9(inst[4]),
                 .pin10(),
                 .pin11(clk),
                 .pin12(inst[3]),
                 .pin13(dq[3]),
                 .pin14(dq[2]),
                 .pin15(inst[2]),
                 .pin16(inst[1]),
                 .pin17(dq[1]),
                 .pin18(dq[0]),
                 .pin19(inst[0]),
                 .pin20()
                 );
   // always@ (posedge clk or negedge rst)
   //   begin
   //      if (rst == 'b0)
   //        begin
   //           inst <= 'b0;
   //        end
   //      else
   //        if (inst_we == 'b0)
   //          begin
   //             inst <= dq;  
   //          end
   //   end // always@ (posedge clk or negedge rst)

   //--------------------------------------------------------------------
   // rA MUX and we control
   //--------------------------------------------------------------------
   wire              ___inst7inst5inst4;
   wire              ___inst7inst5inst4__inst6inst4;
   wire              rA_we_1 = state3_out;
   wire              rA_we_2;
   //wire              rA_we_3;   // this same declaration is done before to avoid compilation error
   // as rA_we_3 is used in a NOR gate some lines above.
   wire              rA_we_3;
   wire              rA_we_12;

   wire              mux_rA_11;
   wire              mux_rA_12 = state3_out;
   
   quadand and4 (
                 .pin1(__inst7inst5),
                 .pin2(_inst[4]),
                 .pin3(___inst7inst5inst4),
                 .pin4(rA_we_2),
                 .pin5(rA_we_1),
                 .pin6(rA_we_12),
                 .pin7(),
                 .pin8(rA_we_3),
                 .pin9(state2_out),
                 .pin10(ldm),
                 .pin11(mux_rA_11),
                 .pin12(sevnotsix),
                 .pin13(_inst[4]),
                 .pin14()
                 );
   quador or2 (
               .pin1(___inst7inst5inst4),
               .pin2(__inst6inst4),
               .pin3(___inst7inst5inst4__inst6inst4),
               .pin4(___inst7inst5inst4__inst6inst4),
               .pin5(notsevnotsix),
               .pin6(rA_we_2),
               .pin7(),
               .pin8(rA_we),
               .pin9(rA_we_12),
               .pin10(rA_we_3),
               .pin11(mux_rA[2]),
               .pin12(state0_out),
               .pin13(state12_out),
               .pin14()
               );
   wire              mux_rA_01 = state3_out;
   wire              mux_rA_02;
   wire              mux_rA_03;
   wire              mux_rA_0_12;
   
   quadand and5 (
                 .pin1(mux_rA_11),
                 .pin2(mux_rA_12),
                 .pin3(mux_rA[1]),
                 .pin4(_inst[6]),
                 .pin5(inst[5]),
                 .pin6(mux_rA_02),
                 .pin7(),
                 .pin8(mux_rA_0_12),
                 .pin9(mux_rA_01),
                 .pin10(mux_rA_02),
                 .pin11(mux_rA[0]),
                 .pin12(mux_rA_0_12),
                 .pin13(mux_rA_03),
                 .pin14()
                 );
   wire              den_fc_1;
   
   quador or3 (
               .pin1(_inst[4]),
               .pin2(notsevnotsix),
               .pin3(mux_rA_03),
               .pin4(state1_out),
               .pin5(state2_out),
               .pin6(den_fc_1),
               .pin7(),
               .pin8(cen_fc_sc),
               .pin9(cen_fc),
               .pin10(cen_sc),
               .pin11(_cen),
               .pin12(cen_fc_sc),
               .pin13(cen_tc),
               .pin14()
               );
   // assign rA_we = (state3_out) && ((_inst[7]) && (_inst[5]) && (_inst[4]) || notsevnotsix || (_inst[6]) && (_inst[4])) || (state2_out && ldm);
   // assign mux_rA[1] = (state3_out) && sevnotsix && (_inst[4]) ;
   // assign mux_rA[2] = state0_out || state1_out || state2_out;
   // assign mux_rA[0] = (state3_out) && ((_inst[6]) && (inst[5]) && 
   //                                     (_inst[4]) || notsevnotsix);

   //--------------------------------------------------------------------
   // rB MUX and we control
   //--------------------------------------------------------------------
   wire              rB_we_1 = state3_out;
   wire              rB_we_2;
   wire              rM_we_1 = state3_out;
   wire              rM_we_2;
   quadand and6 (                              
                 .pin1(state3_out),
                 .pin2(swmb),
                 .pin3(mux_rB),
                 .pin4(sevnotsix),
                 .pin5(_inst[5]),
                 .pin6(rB_we_2),
                 .pin7(),
                 .pin8(rB_we),
                 .pin9(rB_we_1),
                 .pin10(rB_we_2),
                 .pin11(rM_we_2),
                 .pin12(sevnotsix),
                 .pin13(inst[4]),
                 .pin14()
                 );
   // assign mux_rB = ((state3_out)) && swmb;
   // assign rB_we  = ((state3_out)) && (sevnotsix && (_inst[5]));

   //--------------------------------------------------------------------
   // rM MUX control
   //--------------------------------------------------------------------
   
   quadand and7 (
                 .pin1(rM_we_1),
                 .pin2(rM_we_2),
                 .pin3(rM_we),
                 .pin4(swmb),
                 .pin5(state3_out),
                 .pin6(mux_rM[0]),
                 .pin7(),
                 .pin8(mux_rM[1]),
                 .pin9(state3_out),
                 .pin10(sevsix),
                 .pin11(den_fc),
                 .pin12(stm),
                 .pin13(den_fc_1),
                 .pin14()
                 );

   // assign rM_we = ((state3_out)) && (sevnotsix && (inst[4]));
   // assign mux_rM[0] = ((state3_out)) && swmb;
   // assign mux_rM[1] = ((state3_out)) && sevsix;

   //--------------------------------------------------------------------
   // den control
   //--------------------------------------------------------------------
   // assign den_fc = ((state2_out) || (state1_out)) && stm;
   
   // always @(posedge clk or negedge rst)
   //   begin
   //      if (rst == 'b0)
   //        begin
   //           den <= 1'b0;
   //        end
   //      else
   //        begin
   //           den <= den_fc;
   //        end
   //   end

   //--------------------------------------------------------------------
   // cen control
   //--------------------------------------------------------------------
   // always @(posedge clk or negedge rst)            
   //   begin
   //      if (rst == 'b0)
   //        begin
   //           cen <= 1'b1;
   //        end
   //      else
   //        begin
   //           cen <= ~(cen_fc || cen_sc || cen_tc);
   //        end
   //   end
   wire              _wen_fc;
   wire              oen_sc_1;
   wire              _rpl_fc_2;
   wire              rpl_fc_2;
   wire              rpl_fc_1 = sevsix;
   
   quadand and8 (
                 .pin1(state3_out),
                 .pin2(ldm),
                 .pin3(cen_sc),
                 .pin4(state2_out),
                 .pin5(stm),
                 .pin6(_wen_fc),
                 .pin7(),
                 .pin8(oen_sc),
                 .pin9(oen_sc_1),
                 .pin10(ldm),
                 .pin11(rpl_fc),
                 .pin12(rpl_fc_2),
                 .pin13(rpl_fc_1),
                 .pin14()
                 );
   dualdff pair4 (
                  .pin1(rst),
                  .pin2(den_fc),
                  .pin3(clk),
                  .pin4(),
                  .pin5(den),
                  .pin6(),
                  .pin7(),
                  .pin8(),      
                  .pin9(cen),
                  .pin10(rst),
                  .pin11(clk),
                  .pin12(cen_in),
                  .pin13(),
                  .pin14()
                  );
   
   //--------------------------------------------------------------------
   // wen control
   //--------------------------------------------------------------------
   wire              oen_in;
   wire              cmp10_or;
   wire              _cmp10_or;
   wire              _cmp0;
   wire              _cmp1;
   dualdff pair5 (
                  .pin1(),
                  .pin2(wen_fc),
                  .pin3(clk),
                  .pin4(rst),
                  .pin5(wen),
                  .pin6(),
                  .pin7(),
                  .pin8(),      
                  .pin9(oen),
                  .pin10(rst),
                  .pin11(clk),
                  .pin12(oen_in),
                  .pin13(),
                  .pin14()
                  );
   hex_inv inv2(
                .pin1(_wen_fc),
                .pin2(wen_fc),
                .pin3(_oen),
                .pin4(oen_in),
                .pin5(_rpl_fc_2),
                .pin6(rpl_fc_2),
                .pin7(),
                .pin8(_cmp10_or),
                .pin9(cmp10_or),
                .pin10(_cmp1),
                .pin11(cmp[1]),
                .pin12(_cmp0),
                .pin13(cmp[0]),
                .pin14()
                );
   // assign wen_fc = (state2_out) && stm;
   
   // always @(posedge clk or negedge rst)
   //   begin
   //      if (rst == 'b0)
   //        begin
   //           wen <= 1'b1;
   //        end
   //      else
   //        begin
   //           wen <= ~wen_fc;
   //        end
   //   end

   //--------------------------------------------------------------------
   // oen control
   //--------------------------------------------------------------------
   
   quador or4 (
               .pin1(state2_out),
               .pin2(state3_out),
               .pin3(oen_sc_1),
               .pin4(oen_sc),
               .pin5(oen_fc),
               .pin6(_oen),
               .pin7(),
               .pin8(_rpl_fc_2),
               .pin9(inst[5]),
               .pin10(inst[4]),
               .pin11(cmp10_or),
               .pin12(cmp[1]),
               .pin13(cmp[0]),
               .pin14()
               );
   assign oen_fc = (state5_out);
   // assign oen_sc = (state2_out || state3_out) && ldm;
   
   // always @(posedge clk or negedge rst)
   //   begin
   //      if (rst == 'b0)
   //        begin
   //           oen <= 1'b1;
   //        end
   //      else
   //        begin
   //           oen <= ~(oen_fc || oen_sc);
   //        end
   //   end

   //--------------------------------------------------------------------
   // alu control
   //--------------------------------------------------------------------
   assign alu_ctrl = inst[5:4]; 
   
   //--------------------------------------------------------------------
   // program counter increment control
   //--------------------------------------------------------------------
   assign rP_inc = (state4_out);
   
   //--------------------------------------------------------------------
   // program counter load from rM control
   //--------------------------------------------------------------------
   wire              _inst5inst4;
   wire              rpl_sc_1;
   wire              cmp_1_0_and;
   wire              inst5_inst4;
   wire              rpl_tc_1;
   wire              inst5inst4;
   wire              rpl_fourth_case_1;
   wire              cmp1_0_and;
   quadand and9 (
                 .pin1(_inst[5]),
                 .pin2(inst[4]),
                 .pin3(_inst5inst4),
                 .pin4(_inst5inst4),
                 .pin5(sevsix),
                 .pin6(rpl_sc_1),
                 .pin7(),
                 .pin8(rpl_sc),
                 .pin9(rpl_sc_1),
                 .pin10(_cmp10_or),
                 .pin11(cmp_1_0_and),
                 .pin12(_cmp1),
                 .pin13(cmp[0]),
                 .pin14()
                 );
   quadand and10 (
                  .pin1(inst[5]),
                  .pin2(_inst[4]),
                  .pin3(inst5_inst4),
                  .pin4(inst5_inst4),
                  .pin5(sevsix),
                  .pin6(rpl_tc_1),
                  .pin7(),
                  .pin8(rpl_tc),
                  .pin9(rpl_tc_1),
                  .pin10(cmp_1_0_and),
                  .pin11(cmp1_0_and),
                  .pin12(cmp[1]),
                  .pin13(_cmp0),
                  .pin14()
                  );
   wire              rpl_fc_sc;
   wire              rpl_tc_fourth_case;
   wire              rpl_fc_sc_tc_fourth_case;
    quadand and11 (
                  .pin1(inst[4]),
                  .pin2(inst[5]),
                  .pin3(inst5inst4),
                  .pin4(inst5inst4),
                  .pin5(sevsix),
                  .pin6(rpl_fourth_case_1),
                  .pin7(),
                  .pin8(rpl_fourth_case),
                  .pin9(rpl_fourth_case_1),
                  .pin10(cmp1_0_and),
                  .pin11(rP_load),
                  .pin12(state3_out),
                  .pin13(rpl_fc_sc_tc_fourth_case),
                  .pin14()
                   );
   wire              ac_fc_2;
   
   quador or5 (
               .pin1(rpl_fc),
               .pin2(rpl_sc),
               .pin3(rpl_fc_sc),
               .pin4(rpl_tc),
               .pin5(rpl_fourth_case),
               .pin6(rpl_tc_fourth_case),
               .pin7(),
               .pin8(rpl_fc_sc_tc_fourth_case),
               .pin9(rpl_tc_fourth_case),
               .pin10(rpl_fc_sc),
               .pin11(ac_fc_2),
               .pin12(ldm),
               .pin13(stm),
               .pin14()
               );
   //   assign rpl_fc = (sevsix && (~(inst[5] || inst[4])));
   // assign rpl_sc = (sevsix && _inst[5] && inst[4]) && 
   //                 ((~cmp[1]) && (~cmp[0])) ;
   // assign rpl_tc = (sevsix && inst[5] && (_inst[4])) && 
   //                 ((~cmp[1]) && cmp[0]) ;
   // assign rpl_fourth_case = (sevsix && (inst[5]) && (inst[4])) && 
   //                          (cmp[1] && (~cmp[0])) ;
   // assign rP_load = ((state3_out)) && 
   //                  (rpl_fc || rpl_sc || rpl_tc || rpl_fourth_case);
   
   //--------------------------------------------------------------------
   // Address control signal for MUX
   //-------------------------------------------------------------------- 
    quadand and12 (
                  .pin1(state3_out),
                  .pin2(ac_fc_2),
                  .pin3(ac_fc),
                  .pin4(state2_out),
                  .pin5(stm),
                  .pin6(ac_sc),
                  .pin7(),
                  .pin8(),
                  .pin9(),
                  .pin10(),
                  .pin11(),
                  .pin12(),
                  .pin13(),
                  .pin14()
                   );
   wire              addr_ctrl_1;
   wire              addr_ctrl_2;
   
   quador or6 (
               .pin1(ac_fc),
               .pin2(ac_sc),
               .pin3(addr_ctrl_1),
               .pin4(state1_out),
               .pin5(state0_out),
               .pin6(addr_ctrl_2),
               .pin7(),
               .pin8(addr_ctrl),
               .pin9(addr_ctrl_1),
               .pin10(addr_ctrl_2),
               .pin11(),
               .pin12(),
               .pin13(),
               .pin14()
               );
   // assign ac_fc =  state3_out && (ldm || stm);
   // assign ac_sc =  state2_out && stm;
   // assign addr_ctrl = ac_fc || ac_sc || state1_out || state0_out;
   
endmodule
