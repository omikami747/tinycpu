BEH=../rtl/beh
STRUCT= ../rtl/struct
ALL_STRUCT= ../test/tinycpu_test.v ../sim/sram.v $(STRUCT)/sim_env.v $(STRUCT)/toplevel.v $(STRUCT)/cmp.v $(STRUCT)/alu.v $(STRUCT)/data_path.v $(STRUCT)/cpu_reg.v $(STRUCT)/cpu_ctrl_op.v $(STRUCT)/sram_ctrl.v $(STRUCT)/mux_8to1.v $(STRUCT)/mux_2to1.v $(STRUCT)/mux_4to1.v

ALL_BEH= ../test/tinycpu_test.v ../sim/sram.v $(BEH)/sim_env.v $(BEH)/toplevel.v $(BEH)/cmp.v $(BEH)/alu.v $(BEH)/data_path.v $(BEH)/cpu_reg.v $(BEH)/cpu_ctrl.v $(BEH)/sram_ctrl.v


model.out: ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v program.mem
	iverilog -DMODEL ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v -o model.out
beh.out:$(ALL_STRUCT) program.mem
	iverilog -DBEH $(ALL_BEH) -o beh.out
str.out: $(ALL_STRUCT) program.mem
	iverilog $(ALL_STRUCT) -o str.out
model_dbg.out: ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v program.mem
	iverilog -DMODEL -DDEBUG ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v -o model_dbg.out
beh_dbg.out:$(ALL_BEH) program.mem
	iverilog -DBEH -DDEBUG $(ALL_BEH) -o beh_dbg.out
str_dbg.out: $(ALL_STRUCT) program.mem
	iverilog -DDEBUG $(ALL_STRUCT) -o str_dbg.out
clean:
	rm -rf ../run/*
	touch .gitignore
