	LDI strg	
	LDI strg
	SWAB
	LDI 15     	## initial value of iterator address stored at address=253
	LDI 13
	CPAM
	SWAB
	STM
	LDI 0	
	LDI 1
	SWAB
	LDI 15     	## initial value of array_sorted stored at address=255	
	LDI 15
	CPAM
	SWAB
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
	JE display
	LDI 0	
	LDI 1
	SWAB
	LDI 15     	##	
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

loop:  			## temp_inst
	LDI 15
	LDI 13
	CPAM
	LDM
	CPAM
	LDM
	SWAB
	LDI 15
	LDI 14
	SWAB
	SWMB
	STM
	CPAM
	LDI 0
	LDI 1
	ADD
	SWMB
	CPAM
	LDM
	JL swap
	LDI 15
	LDI 13
	CPAM
	LDM
	SWAB
	LDI 0
	LDI 1
	ADD
	STM
	JU addr_check
display:
	LDI strg	
	LDI strg
	CPAM
	LDM
	SWMB
	LDI 0
	LDI 1
	ADD
	CPAM
	LDM
	SWMB
	LDI 0
	LDI 1
	ADD
	CPAM
	LDM
	SWMB		#  display code for each contiguous mem location
	LDI 0		#
	LDI 1		#
	ADD		#
	CPAM		#
	LDM		#
	SWMB		#  display code for each contiguous mem location
	LDI 0		#
	LDI 1		#
	ADD		#
	CPAM		#
	LDM		#
	
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
	.word 11
	.word 9
	.word 14
	.word 13
end:
	.word 16
