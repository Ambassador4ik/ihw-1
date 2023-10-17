# Array handler module
# Fills array B with numbers: B = A.Select(x => x % 10 == 4 ? x / 2 : x)
# IN: a1 - array element count
# IN: a2 - source array address
# IN: a3 - destination array address
.include "stack.asm"
.text 
.globl array_handler

	array_handler:
	
	init:
		SPUSH(ra)
		SPUSH(s0)
		SPUSH(s1)
		SPUSH(s2)
		SPUSH(s3)
		
		mv s0 a1	# Element count
		mv s1 a2	# Array A
		mv s2 a3	# Array B
		li t0 0 	# Counter
		
	loop:
		beq s0 t0 loop_end
		
		lw s3 (s1)	# Load number from the first array
		
		j number_handler
		cont:

		sw s3 (s2)	# Store updated value in the second array
		
		addi s1 s1 4
		addi s2 s2 4	
		addi t0 t0 1	# Update counters
		
		j loop
	
	number_handler:
		li t1 10
		rem t2 s3 t1 	# Last digit of s3, but with sign
		
		li t3 4
		li t4 -4
		
		beq t2 t3 di
		beq t2 t4 di 	# Check if last digit is 4 
		
		j cont
		
	di:
		srai s3 s3 1	# Divide s3 by 2 
		j cont
	
	loop_end:
		SPOP(s3)
		SPOP(s2)
		SPOP(s1)
		SPOP(s0)
		SPOP(ra)
		ret
