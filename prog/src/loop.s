# loop.s -- loop till overflow.

        ## LDI 8
        ## LDI 0
        ## CPAM                 # M = 0x80
        ## LDI 4
        ## LDI 5
        ## STM                   # RAM[0x80] <= 0x54
        LDI 0
        LDI 2                   # A <= 2
        SWAB                    # A <= 0, B <= 2
        CPPA                    # M <= P
        ADD
        CPAM
        ##  Loop body
        SWAB
        LDI 0
        LDI 1
        SWAB
        ADD                     # A <= A + B
        JG

        ## Test loads.
        ## LDI 8
        ## LDI 0                   # A <= 0x80
        ## CPAM
        ## LDM                    # A <= RAM[0x80]

        ## Program done, forever loop.
        LDI 0
        LDI 2
        SWAB
        CPPA
        ADD
        CPAM
        JU                       # Loop forever (halt).
