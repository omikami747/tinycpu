	LDI disp_it   	## temp, remove after test
	LDI disp_it
	LDI strg	## iterator val at addr-253, current element or [addr] at addr-254
	LDI strg	## initial value of iterator address stored at address=255
	SWAB		##############################################################
	LDI 15		## IN THIS CODE, PC=117 DISPLAYS SORTED VALUES IN LOG FILES ##
	LDI 13		##############################################################
	CPAM
	SWAB
	STM
	LDI 0
	LDI 1
	SWAB
	LDI 15     	## initial value of tmp = array_sorted stored at address=255
	LDI 15
	CPAM
	SWAB
	STM
	LDI disp_it 		## display iterator loading
	LDI disp_it
	CPAM
	LDI strg
	LDI strg
	STM
addr_check:
	LDI 15  	## checks if iterator address is equal to end address
	LDI 13
	CPAM
	LDM
	SWAB
	LDI end
	LDI end
	JG loop 	## if iterator is lesser than end address then jump
	LDI 15		## if iterator is equal to end address then check tmp
	LDI 15		## at address 255
	CPAM
	SWAB
	LDM
	SWAB
	LDI 0
	LDI 1		## imp -> change this later to 1
	JE display	## checking tmp value to get whether array sorted or not
	LDI 0
	LDI 1
	SWAB
	LDI 15
	LDI 15
	CPAM
	SWAB
	STM
	LDI strg
	LDI strg
	SWAB
	LDI 15     	## value of iterator address stored at address=253 is rst
	LDI 13
	CPAM
	SWAB
	STM

loop:
	LDI 15		## getting addr value from 253
	LDI 13
	CPAM
	LDM
	CPAM
	LDM             ## getting [addr]
	SWAB
	LDI 15
	LDI 14
	SWAB
	SWMB
	STM             ## storing [addr] at 254
	CPAM
	LDI 0
	LDI 1
	ADD
	SWMB
	CPAM
	LDM             ## getting [addr+1]
	JL swap         ## check [addr] > [addr+1]
	LDI 15		## jump taken for above condition
	LDI 13
	CPAM
	LDM
	SWAB
	LDI 0
	LDI 1
	ADD		## increment addr stored at 253
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
	SWAB     ## putting [addr+1] at addr
	LDI 15
	LDI 13
	CPAM
	LDM
	CPAM
	SWAB
	STM
	LDI 15   ## increment address at 253
	LDI 13
	CPAM
	LDM
	SWAB
	LDI 0
	LDI 1
	ADD
	STM
	SWAB	## putting old [addr] at addr+1
	LDI 15
	LDI 14
	CPAM
	LDM
	SWMB
	STM
	LDI 0	## setting tmp at 255 to zero
	LDI 0
	SWAB
	LDI 15
	LDI 15
	CPAM
	SWAB
	STM
	JU addr_check
strg:
	.word 92
	.word 120
	.word 34
	.word 135
	.word 167
	.word 5
	.word 44
	.word 90
	.word 249
	.word 229
	.word 45
	.word 10
	.word 167
	.word 91
	.word 3
	.word 37
	.word 242
	.word 122
	.word 81
	.word 147
	.word 228
	.word 60
	.word 126
	.word 229
	.word 75
	.word 246
	.word 144
	.word 31
	.word 240
	.word 143
	.word 241
	.word 102
	.word 55
	.word 153
	.word 31
	.word 156
	.word 89
	.word 163
	.word 76
	.word 15
	.word 74
	.word 139
	.word 30
	.word 157
	.word 21
	.word 255
	.word 32
	.word 204
	.word 179
	.word 143
	.word 73
	.word 133
	.word 118
	.word 85
	.word 32
	.word 131
	.word 141
	.word 101
	.word 228
end:
	.word 8
disp_it:
	.word 0
