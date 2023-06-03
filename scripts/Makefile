STRUCT = ../rtl/struct/
ALL_STRUCT = $(STRUCT)tinycpu_test.v $(STRUCT)sram.v $(STRUCT)sim_env.v $(STRUCT)toplevel.v $(STRUCT)cmp.v $(STRUCT)alu.v $(STRUCT)data_path.v $(STRUCT)cpu_reg.v $(STRUCT)cpu_ctrl.v $(STRUCT)sram_ctrl.v



beh.out: ../model/tinycpu.v ../model/sram.v ../model/tinycpu_test.v program.mem
	iverilog ../model/tinycpu.v ../model/sram.v ../model/tinycpu_test.v -o beh.out
struct.out: $(ALL_STRUCT) program.mem
	iverilog $(ALL_STRUCT) -o struct.out
clean:
	rm -rf ../run/*
