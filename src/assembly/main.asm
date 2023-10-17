.include "macros.asm"
.text 
.globl main 	# Needed for "Start Main" RARS feature to work

	main:
		PRINT_STR("Enter array element count: ")
		READ_INT(s0) 			# Read N and store address in s0
		NEWLINE
		
		CHECK_INPUT(s0) 		# Load and check N
		
		CREATE_ARRAY(s0)		# Init A
		mv s1 a0			# Store array address in s1
		
		READ_ARRAY(s0, s1)		# Read array A from console
		
		CREATE_ARRAY(s0)		# Init B
		mv s2 a0			# Store array address in s2
		
		NEWLINE
		HANDLE_ARRAY(s0, s1, s2)	# Fill array B
		PRINT_ARRAY(s0, s2)		# Print array B
		NEWLINE
		
		EXIT
