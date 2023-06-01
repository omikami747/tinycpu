# STRUCT = rtl/struct/
# ALL_STRUCT = $(STRUCT)tinycpu_test.v $(STRUCT)sram.v $(STRUCT)sim_env.v $(STRUCT)toplevel.v $(STRUCT)cmp.v $(STRUCT)alu.v $(STRUCT)data_path.v $(STRUCT)cpu_reg.v $(STRUCT)cpu_ctrl.v $(STRUCT)sram_ctrl.v
# SOURCES := $(shell find prog/)

# run: emulog rtllog structurallog
# 	diff -q artifacts/rtllog artifacts/emulog
# 	diff -q artifacts/structurallog artifacts/emulog

# .PHONY: bin.out emulog rtllog structurallog clean
# bin.out:
# 	mkdir -p artifacts
# 	./prog/asm/asm $(ASM) -o bin.out
# 	mv bin.out artifacts/

# emulog: prog/asm/asm prog/emu/emu $(SOURCES) bin.out
# 	./prog/emu/emu artifacts/bin.out > artifacts/emulog

behout: ../model/tinycpu.v ../model/sram.v ../model/tinycpu_test.v bin.out
	iverilog ../model/tinycpu.v ../model/sram.v ../model/tinycpu_test.v -o behout

# structurallog: $(ALL_STRUCT) bin.out
# 	./prog/bin2readmemh/bin2readmemh artifacts/bin.out > program.mem
# 	iverilog -o struct_vvp $(STRUCT)*.v
# 	./struct_vvp > tmp2
# 	tail -n +2 tmp2 > structurallog
# 	rm tmp2
# 	mv struct_vvp artifacts/
# 	mv structurallog artifacts/
# 	mv structural_dump.vcd artifacts/
# 	mv program.mem artifacts/

# clean:
# 	rm -rf artifacts
