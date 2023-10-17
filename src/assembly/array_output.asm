# Array output module
# Prints space-separated array elements
# IN: a1 - array element count
# IN: a2 - array address
# OUT: N/A
.include "stack.asm"
.data 
	hint: .asciz "Result: "
.text 
.globl array_output
	array_output:
	
	init:
		SPUSH(ra)
		SPUSH(s0)
		SPUSH(s1)
		
		mv s0 a1	# Element count
		mv s1 a2	# Array
		li t0 0		# Counter
		
		li a7 4
		la a0 hint
		ecall		# Print hint
	
	loop:
		beq s0 t0 loop_end
	
		li a7 1
		lw a0 (s1)
		ecall		# Print number
		
		li a7 11
		li a0 32	# ASCII 32 is whitespace
		ecall		# Print separator
		
		addi s1 s1 4	
		addi t0 t0 1	# Update counters
		
		j loop
	
	loop_end:
		SPOP(s1)
		SPOP(s0)
		SPOP(ra)
		ret
