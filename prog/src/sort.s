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
        .word 175
        .word 182
        .word 13
        .word 61
        .word 13
        .word 94
        .word 141
        .word 82
        .word 214
        .word 253
        .word 181
        .word 108
        .word 50
        .word 205
        .word 174
        .word 206
        .word 196
        .word 135
        .word 157
        .word 143
        .word 151
        .word 49
        .word 250
        .word 31
        .word 46
        .word 236
        .word 28
        .word 234
        .word 129
        .word 246
        .word 221
        .word 235
        .word 55
        .word 235
        .word 200
        .word 103
        .word 64
        .word 137
        .word 131
        .word 59
        .word 240
        .word 122
        .word 183
        .word 246
        .word 214
        .word 29
end:
        .word 152
