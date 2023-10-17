.macro SPUSH(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

.macro SPOP(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro
