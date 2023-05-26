# Test code for tiny CPU.

        LDI 0x5                  # A = x5
        LDI 4                    # A = x54
        SWAB                     # A = x0, B = x54
        LDI 2                    # A = x42, B = x54
        LDI 4                    # A = x24, B = x54
        ADD                      # A = x78, B = x54
        LDI 0                    # A = x80
        INV
        INV
loop:
        SWAB
        SWMB
        SWAB
        LDI 0
        LDI 1
        SWAB
        ADD                     # B <= B + 1
        SWMB
        SWAB
        JG loop

loop_forever:
        JU loop_forever          # Loop forever (halt).
