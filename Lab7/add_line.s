.text

## void add_line(unsigned int start_pos, unsigned int end_pos,
##               unsigned int* canvas, unsigned int* origins) {
##     int step_size = 1;
##     // Check if the line is vertical.
##     if (!((start_pos ^ end_pos) & 31)) {
##         step_size = 32;
##     }
##     if (start_pos > end_pos) {
##         step_size *= -1;
##     }
##     // Update the origin map.
##     add_dot(end_pos, canvas);
##     for (int i = start_pos; i != end_pos; i += step_size) {
##         add_dot(i, canvas);
##         origins[get_origin(i + step_size, origins)] = get_origin(i, origins);
##     }
## }

.globl add_line
add_line:
	# Your code goes here :)
	move $t0, $a0
	move $t1, $a1
	move $t2, $a0
	li $s3,1
	ToN:
		beq $t1, 0, if1
		mul $t2, $t2, $t0
		sub $t1, $t1, 1
		j ToN
	if1:
		and $t2, $t2, 31
		bne $t2, 0, if2
		li $s3,32
	if2:
		beq $a0, $a1, if3
		blt $a0, $a1, if3
		mul $s3, $s3, -1
	if3:
		sub $sp, $sp,20
		sw $ra,0,($sp)
		sw $a0,4,($sp)
		sw $a1,8,($sp)	
		move $a0, $a1
		move $a1, $a2	
		jal add_dot
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		sw $a0,16,($sp)
	forloop:		
		lw $a1, 8($sp)
		beq $a0, $a1, done
		move $a1, $a2
		lw $a0, 16($sp)
		jal add_dot
		move $a1, $a3
		jal get_origin
		sw $v0,12,($sp)		
		lw $a0,16,($sp)
		add $a0, $a0, $s3	
		jal get_origin
		mul $t6, $v0, 4
		add $t4, $a3,$t6
		lw $t5,12,($sp)
		sw $t5, 0($t4)
		lw $a0,16,($sp)
		add $a0, $a0,$s3
		sw $a0,16,($sp)
		##j forloop
	done:	
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $ra, 0($sp)	
		add $sp,$sp,20
		jr	$ra
