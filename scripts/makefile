BEH=../rtl/beh
STRUCT= ../rtl/struct
STRUCT74= ../rtl/struct74
ALL_STRUCT= ../test/tinycpu_test.v ../sim/sram.v $(STRUCT)/sim_env.v $(STRUCT)/toplevel.v $(STRUCT)/cmp.v $(STRUCT)/alu.v $(STRUCT)/data_path.v $(STRUCT)/cpu_reg.v $(STRUCT)/cpu_ctrl_op.v $(STRUCT)/sram_ctrl.v $(STRUCT)/mux_8to1.v $(STRUCT)/mux_2to1.v $(STRUCT)/mux_4to1.v

ALL_BEH= ../test/tinycpu_test.v ../sim/sram.v $(BEH)/sim_env.v $(BEH)/toplevel.v $(BEH)/cmp.v $(BEH)/alu.v $(BEH)/data_path.v $(BEH)/cpu_reg.v $(BEH)/cpu_ctrl.v $(BEH)/sram_ctrl.v

ALL_STRUCT74= ../test/tinycpu_test.v ../sim/sram.v $(STRUCT74)/sim_env.v $(STRUCT74)/toplevel.v $(STRUCT74)/cmp.v $(STRUCT74)/alu.v $(STRUCT74)/data_path.v $(STRUCT74)/cpu_reg.v $(STRUCT74)/cpu_ctrl_op.v $(STRUCT74)/sram_ctrl.v $(STRUCT74)/mux_8to1.v $(STRUCT74)/mux_2to1.v $(STRUCT74)/mux_4to1.v $(STRUCT74)/quadnand.v $(STRUCT74)/quadnor.v $(STRUCT74)/quador.v $(STRUCT74)/quadand.v $(STRUCT74)/hex_inv.v $(STRUCT74)/dualdff.v $(STRUCT74)/reg8bit.v $(STRUCT74)/cmp4bit.v


model.out: ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v program.mem
	iverilog -DMODEL ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v -o model.out
beh.out:$(ALL_STRUCT) program.mem
	iverilog -DBEH $(ALL_BEH) -o beh.out
str.out: $(ALL_STRUCT) program.mem
	iverilog -DSTR $(ALL_STRUCT) -o str.out
str74.out: $(ALL_STRUCT74) program.mem
	iverilog $(ALL_STRUCT74) -o str74.out
model_dbg.out: ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v program.mem
	iverilog -DMODEL -DDEBUG ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v -o model_dbg.out
beh_dbg.out:$(ALL_BEH) program.mem
	iverilog -DBEH -DDEBUG $(ALL_BEH) -o beh_dbg.out
str_dbg.out: $(ALL_STRUCT) program.mem
	iverilog -DSTR -DDEBUG $(ALL_STRUCT) -o str_dbg.out
str74_dbg.out: $(ALL_STRUCT74) program.mem
	iverilog -DDEBUG $(ALL_STRUCT74) -o str74_dbg.out
clean:
	rm -rf ../run/*
	touch .gitignore
