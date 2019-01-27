.text

## struct Lines {
##     unsigned int num_lines;
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];
## };
## 
## struct Solution {
##     unsigned int length;
##     int* counts;
## };
## 
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct. 
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##     for (unsigned int i = 0; i < lines->num_lines; i++) {
##         unsigned int start_pos = lines->coords[0][i];
##         unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##         draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##         unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;
##     }
## }

.globl count_disjoint_regions
count_disjoint_regions:
        # Your code goes here :)
		sub $sp, $sp, 24
		sw $ra, 0($sp)
		sw $s0, 4($sp)		##s0:a0
		sw $s1, 8($sp)		##s1:a1
		sw $s2, 12($sp)		##s2:a2
		sw $s3, 16($sp)		##s3:i
		sw $s4, 20($sp)		##s4:num
		move $s0,$a0
		move $s1,$a1
		move $s2,$a2
		li $s3,0
		lw $s4,0($s0)
loop:
		bge $s3,$s4, skip
		lw $t1,4($s0)
		mul $t2, $s3,4
		add $t1, $t1, $t2
		lw $t1, 0($t1)		##t1:startpos
		lw $t2,8($s0)
		mul $t3, $s3,4
		add $t2, $t3, $t2
		lw $t2,0($t2)		##t2:endpos
		move $a0,$t1
		move $a1,$t2
		move $a2,$s1
		jal draw_line		
		rem $t5, $s3, 2
		li $t4,'A'
		add $t4, $t4, $t5
		move $a0, $t4
		move $a1, $s1
		jal count_disjoint_regions_step
		lw $t6, 4($s2)
		mul $t7,$s3,4
		add $t6,$t6,$t7
		sw $v0,0($t6)

		add $s3,$s3,1
		j loop
skip:   
		lw $ra, 0($sp)
		lw $s0, 4($sp)		
		lw $s1, 8($sp)		
		lw $s2, 12($sp)		
		lw $s3, 16($sp)	
		lw $s4, 20($sp)	  
		add $sp, $sp, 24 
		jr      $ra
