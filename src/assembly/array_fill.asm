# Array fill module
# Reads numbers from console and saves them to the array
# IN: a1 - array element count
# IN: a2 - array address
# OUT: N/A
.include "stack.asm"
.data
	prompt: .asciz "Enter Number: "
.text 
.globl array_fill

	array_fill:
		
	init:
		SPUSH(ra)
		SPUSH(s0)
		SPUSH(s1)
		
		mv s0 a1	# Element count
		mv s1 a2	# Array
		li t0 0		# Counter
	
	loop:
		beq s0 t0 loop_end
	
		li a7 4
		la a0 prompt
		ecall		# Print prompt
		
		li a7 5
		ecall		# Ask for number
		
		sw a0 (s1)	# Save number
		
		addi s1 s1 4	
		addi t0 t0 1	# Update counters
		
		j loop
	
	loop_end:
		SPOP(s1)
		SPOP(s0)
		SPOP(ra)
		ret
