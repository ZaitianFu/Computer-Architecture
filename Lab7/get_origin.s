.text

## unsigned int get_origin(unsigned int pos, unsigned int* origins) {
##     while (pos != origins[pos]) {
##         pos = origins[pos];
##     }
##     return pos;
## }

.globl get_origin
get_origin:
	# Your code goes here :)
	loop:
		sll $t0, $a0, 2
		add $t0, $t0, $a1
		lw $t0, 0($t0)
		beq $t0, $a0, ret
		move $a0, $t0
		j loop
	ret:
		move $v0,$a0
	jr	$ra
