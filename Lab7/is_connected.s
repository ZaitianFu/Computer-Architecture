.text

## bool is_connected(unsigned int pos1, unsigned int pos2,
##                   unsigned int* origins) {
##     return get_origin(pos1, origins) == get_origin(pos2, origins);
## }

.globl is_connected
is_connected:
	# Your code goes here :)
	sub $sp, $sp, 12
	sw $ra,0, ($sp)
	sw $a1,4, ($sp)
	move $a1, $a2
	jal get_origin
	## move $t0, $v0
	sw $v0,8, ($sp)
	lw $a0, 4($sp)	
	jal get_origin
	lw $a1, 4($sp)
	lw $t0, 8($sp)

	lw $ra,0, ($sp)
	add $sp, $sp, 12
	beq $t0, $v0, eq
	li $v0,0
	jr	$ra
eq:
	li $v0, 1	
	jr	$ra
