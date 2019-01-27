.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
## 
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,
##                                          Canvas* canvas) {
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
        # Your code goes here :)
		sub $sp,$sp,32
		sw $ra, 0($sp)
		sw $s0, 4($sp)		##s0=a0
		sw $s1, 8($sp)		##s1=a1
		sw $s2, 12($sp)		##s2=row
		sw $s3, 16($sp)		##s3=col
		sw $s4, 20($sp)		##s4=height
		sw $s5, 24($sp)		##s5=weight
		sw $s6, 28($sp)		##s6=v0
		move $s0, $a0
		move $s1, $a1
		li $s6,0 		##region_count=0
		li $s2,-1		##row=-1
		lw $s4,0 ($a1)		##height
		lw $s5,4 ($a1)		##width
		
loop1:	
		add $s2, $s2,1		
		bge $s2, $s4, skip
		li $s3,0		##col=0
loop2:	
		bge $s3, $s5, loop1
		lw $t0,12 ($s1)
		mul $t1, $s2, 4
		add $t1, $t1, $t0
		lw $t1, 0 ($t1)
		add $t1, $s3, $t1
		lb $t1,0($t1)		##curr_char
		lb $t3,8 ($s1)		##pattern
		beq $t1, $t3, skipif
		beq $t1, $s0, skipif
		add $s6, $s6,1
		move $a0, $s2
		move $a1, $s3
		move $a2, $s0
		move $a3, $s1
		jal flood_fill	
skipif:
		add $s3, $s3, 1
		j loop2		
skip:
		move $v0, $s6
		lw $ra, 0($sp)
		lw $s0, 4($sp)		##s0=a0
		lw $s1, 8($sp)		##s1=a1
		lw $s2, 12($sp)		##s2=row
		lw $s3, 16($sp)		##s3=col
		lw $s4, 20($sp)		##s4=height
		lw $s5, 24($sp)		##s5=weight
		lw $s6, 28($sp)		##s6=v0
		add $sp,$sp,32
        jr      $ra
