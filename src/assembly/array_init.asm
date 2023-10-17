# Array initialisation module
# IN: a1 - array element count
# OUT: a0 - array address
.include "stack.asm"
.text
.globl array_init

	array_init:
		SPUSH(ra)	# Save used registers
		SPUSH(s0)
		
		li t0 4
		mul s0 a1 t0 	# Array size in bytes
		
		mv a0 s0 	# Move array size to sbrk system call argument
		li a7 9 	# Allocate heap memory for array
		ecall
		
		SPOP(s0)
		SPOP(ra) 	# Return registers to their initial values
		
		ret		# Return array address
