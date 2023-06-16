        LDI disp_it     ## temp, remove after test
        LDI disp_it
        LDI strg        ## iterator val at label it_val, current element or [addr] at                   
        LDI strg        ## label curr_elem, value of array sorted stored at label tmp
        SWAB            ##############################################################
        LDI it_val      ## IN THIS CODE, PC=117 DISPLAYS SORTED VALUES IN LOG FILES ##
        LDI it_val      ##############################################################
        CPAM
        SWAB
        STM
        LDI 0
        LDI 1
        SWAB
        LDI tmp         ## initial value of tmp = array_sorted stored at label tmp
        LDI tmp
        CPAM
        SWAB
        STM
        LDI disp_it     ## display iterator loading
        LDI disp_it
        CPAM
        LDI strg
        LDI strg
        STM
addr_check:
        LDI it_val      ## checks if iterator address is equal to end address
        LDI it_val
        CPAM
        LDM
        SWAB
        LDI end
        LDI end
        JG loop         ## if iterator is lesser than end address then jump
        LDI tmp         ## if iterator is equal to end address then check tmp
        LDI tmp         ## at tmp
        CPAM
        SWAB
        LDM
        SWAB
        LDI 0
        LDI 1
        JE display      ## checking tmp value to get whether array sorted or not
        LDI 0
        LDI 1
        SWAB
        LDI tmp
        LDI tmp
        CPAM
        SWAB
        STM
        LDI strg
        LDI strg
        SWAB
        LDI it_val      ## value of iterator address stored at it_val is rst
        LDI it_val
        CPAM
        SWAB
        STM

loop:
        LDI it_val      ## getting addr value from it_val
        LDI it_val
        CPAM
        LDM
        CPAM
        LDM             ## getting [addr]
        SWAB
        LDI curr_elem
        LDI curr_elem
        SWAB
        SWMB
        STM             ## storing [addr] at curr_elem
        CPAM
        LDI 0
        LDI 1
        ADD
        SWMB
        CPAM
        LDM             ## getting [addr+1]
        JL swap         ## check [addr] > [addr+1]
        LDI it_val      ## jump taken for above condition
        LDI it_val
        CPAM
        LDM
        SWAB
        LDI 0
        LDI 1
        ADD             ## increment addr stored at 253
        STM
        JU addr_check

display:
        LDI disp_it
        LDI disp_it
        CPAM
        LDM
        CPAM
        LDM
        LDI 0
        LDI 1
        SWMB
        ADD
        SWAB
        LDI disp_it
        LDI disp_it
        CPAM
        SWAB
        STM
        SWAB
        LDI end
        LDI end
        JL halt
        JU display
halt:
        JU halt

swap:
        SWAB            ## putting [addr+1] at addr
        LDI it_val
        LDI it_val
        CPAM
        LDM
        CPAM
        SWAB
        STM
        LDI it_val      ## increment address at it_val
        LDI it_val
        CPAM
        LDM
        SWAB
        LDI 0
        LDI 1
        ADD
        STM
        SWAB            ## putting old [addr] at addr+1
        LDI curr_elem
        LDI curr_elem
        CPAM
        LDM
        SWMB
        STM
        LDI 0           ## setting value at tmp to zero
        LDI 0
        SWAB
        LDI tmp
        LDI tmp
        CPAM
        SWAB
        STM
        JU addr_check

it_val:
        .word 0
curr_elem:
        .word 0
tmp:
        .word 0
disp_it:
        .word 0
strg:
        .word 163
        .word 166
        .word 222
        .word 76
        .word 126
        .word 91
        .word 211
        .word 190
        .word 95
        .word 115
        .word 253
        .word 155
        .word 87
        .word 136
        .word 116
        .word 64
        .word 223
        .word 168
        .word 216
        .word 15
        .word 226
        .word 46
        .word 149
        .word 73
        .word 60
        .word 183
        .word 27
        .word 240
        .word 112
        .word 201
        .word 67
        .word 69
        .word 89
        .word 13
        .word 13
        .word 240
        .word 164
        .word 28
        .word 209
        .word 48
        .word 228
        .word 90
        .word 180
        .word 65
        .word 204
        .word 173
end:
        .word 222
