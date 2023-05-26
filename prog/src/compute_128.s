# Test code for tiny CPU.

        LDI 0x5                  # A = x5
        LDI 4                    # A = x54
        SWAB                     # A = x0, B = x54
        LDI 2                    # A = x42, B = x54
        LDI 4                    # A = x24, B = x54
        ADD                      # A = x78, B = x54
        LDI 0                    # A = x80
        INV

        ## Program done, forever loop.
        LDI 0
        LDI 2
        SWAB
        CPPA
        ADD
        CPAM
        JU                       # Loop forever (halt).
