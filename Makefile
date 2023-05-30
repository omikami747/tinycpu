STRUCT = rtl/struct/
ALL_STRUCT = $(STRUCT)tinycpu_test.v $(STRUCT)sram.v $(STRUCT)sim_env.v $(STRUCT)toplevel.v $(STRUCT)cmp.v $(STRUCT)alu.v $(STRUCT)data_path.v $(STRUCT)cpu_reg.v $(STRUCT)cpu_ctrl.v $(STRUCT)sram_ctrl.v

run: emulog rtllog structurallog
	$(call check_defined, ASM, file to exec)
	diff -q structurallog emulog  #-q real option, change after test
	diff -q rtllog emulog         #-q real option, change after test

emulog: prog/asm/asm prog/emu/emu
	./prog/asm/asm $(ASM) -o bin.out
	./prog/emu/emu bin.out > emulog

rtllog: model/tinycpu.v model/sram.v model/tinycpu_test.v
	./prog/bin2readmemh/bin2readmemh bin.out > program.mem
	iverilog model/*.v
	./a.out > tmp
	tail -n +2 tmp > rtllog
	rm tmp

structurallog: $(ALL_STRUCT)
	./prog/bin2readmemh/bin2readmemh bin.out > program.mem
	iverilog $(STRUCT)*.v -o struct
	./struct > tmp2
	tail -n +2 tmp2 > structurallog
	rm tmp2

clean:
	rm -f structurallog rtllog emulog program.mem a.out bin.out dump.vcd
