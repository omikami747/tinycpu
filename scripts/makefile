STRUCT = ../rtl/struct/
ALL_STRUCT = ../test/tinycpu_test.v ../sim/sram.v $(STRUCT)sim_env.v $(STRUCT)toplevel.v $(STRUCT)cmp.v $(STRUCT)alu.v $(STRUCT)data_path.v $(STRUCT)cpu_reg.v $(STRUCT)cpu_ctrl.v $(STRUCT)sram_ctrl.v



beh.out: ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v program.mem
	iverilog -DBEH ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v -o beh.out
str.out: $(ALL_STRUCT) program.mem
	iverilog $(ALL_STRUCT) -o str.out
beh_dbg.out: ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v program.mem
	iverilog -DBEH -DDEBUG ../model/tinycpu.v ../sim/sram.v ../test/tinycpu_test.v -o beh_dbg.out
str_dbg.out: $(ALL_STRUCT) program.mem
	iverilog -DDEBUG $(ALL_STRUCT) -o str_dbg.out
clean:
	rm -rf ../run/*
	touch .gitignore
