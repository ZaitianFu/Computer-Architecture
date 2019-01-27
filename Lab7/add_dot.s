.text

## void add_dot(unsigned int pos, unsigned int* canvas) {
##     unsigned int row = pos >> 5;
##     unsigned int col = 31 - (pos & 31);
##     canvas[row] |= (1 << col);
## }

.globl add_dot
add_dot:
	# Your code goes here :)
	srl $t0, $a0, 5		#t0 pos>>5
	and $t1, $a0, 31	#t1 pos&31
	li $t4, 31			#t4 31
	sub $t1, $t4, $t1	#t1 col: 31-(pos&31)
	li $t5, 1			#t5 1
	sll $t5, $t5, $t1	#t5 1<<col
	add $t0, $t0, $t0	#t0 4t0
	add $t0, $t0, $t0
	add $t2, $a1, $t0	#t2 canva[row]
	lw $t6,0 ($t2)
	or $t3, $t5, $t6	#t3 |
	sw $t3, 0 ($t2)		
	jr	$ra
