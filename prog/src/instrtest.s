# instrtest.s - test all instructions

        ## Test AND
        LDI 10
        LDI 10                  # A = AA
        SWAB                    # A = 00, B = AA
        LDI 5
        LDI 5                   # A = 55, B = AA
        AND                     # A = (55 AND AA) = 00

        ## Test OR
        LDI 5
        LDI 5                   # A = 55
        OR                      # A = (55 OR AA) = FF
        
        ## Test INV
        LDI 5
        LDI 5                   # A = 55
        INV                     # A = AA
        INV                     # A = 55

        ## Test ADD
        ADD                     # A = 55 + AA = FF

        ## LDI is already tested :-)
        
        ## Test STM
        LDI 7
        LDI 15                  # A = 7F
        CPAM                    # M = 7F
        LDI 6
        LDI 4                   # A = 64
        STM                     # MEM(7F) = 64

        ## Test LDM
        LDI 0
        LDI 0                   # A = 0
        LDM                     # A = MEM(7F) = 64
        
        ## SWAB is already tested :-)

        ## Test SWMB
        SWMB

        ## Test CPPA
        CPPA

        ## CPAM is already tested :-)

        ## Test JU
        ## Code starting from 80 is this:
        ##      80 LDI 3
        ##      81 LDI B
        ##      82 CPAM
        ##      83 JU
        
        LDI 8
        LDI 0                   # A = 80
        CPAM                    # M = 80
        SWAB                    # B = 80
        LDI 4
        LDI 3                   # A = 43
        STM                     # MEM(7F) = 43 (LDI 3)

        LDI 0
        LDI 1                   # A = 1
        ADD                     # A = 80 + 1 = 81
        CPAM                    # M = 81
        SWAB                    # B = 81
        LDI 4
        LDI 11                  # A = 4B
        STM                     # MEM(81) = 45 (LDI B)

        LDI 0
        LDI 1                   # A = 1
        ADD                     # A = 81 + 1 = 82
        CPAM                    # M = 82
        SWAB                    # B = 82
        LDI 11
        LDI 0                   # A = B0
        STM                     # MEM(82) = B0 (CPAM)

        LDI 0
        LDI 1                   # A = 1
        ADD                     # A = 82 + 1 = 83
        CPAM                    # M = 83
        SWAB                    # B = 83
        LDI 12
        LDI 0                   # A = C0
        STM                     # MEM(83) = A0 (JU)

        LDI 8
        LDI 0
        CPAM
        JU                      # Jump to 80

        ## Program done, forever loop.
        LDI 0
        LDI 2
        SWAB
        CPPA
        ADD
        CPAM
        JU                       # Loop forever (halt).
