load_arr_0:
        LDI array          # An interesting note about the design of labels in
        LDI array          # the assembler is that doing this lets me load a pointer.
        SWAB
        SWMB               # rM now has &(array[0]).
        LDM                # Should have array[0] == 42 in rA

halt:
        JU halt

array:
        .word 42
        .word 0x10         # Syntax supports all Python bases -- dec, hex, bin, oct
        .word 0b110
        .word 0o56
        .word 35
        .word 57
        .word 40
        .word 58
        .word 35
        .word 93

size:
        .word 10
