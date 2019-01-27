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
## // Mark an empty region as visited on the canvas using flood fill algorithm.
## void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
##     // Check the current position is valid.
##     if (row < 0 || col < 0 ||
##         row >= canvas->height || col >= canvas->width) {
##         return;
##     }
##     unsigned char curr = canvas->canvas[row][col];
##     if (curr != canvas->pattern && curr != marker) {
##         // Mark the current pos as visited.
##         canvas->canvas[row][col] = marker;
##         // Flood fill four neighbors.
##         flood_fill(row - 1, col, marker, canvas);
##         flood_fill(row, col + 1, marker, canvas);
##         flood_fill(row + 1, col, marker, canvas);
##         flood_fill(row, col - 1, marker, canvas);
##     }
## }

.globl flood_fill
flood_fill:
        # Your code goes here :)
		sge $t5,$a0, 0
		sge $t6,$a1, 0
		lw $t0, 0($a3)		##t0:height
		lw $t1, 4($a3)		##t1:width
		slt $t7, $a0, $t0
		slt $t8, $a1, $t1
		and $t5, $t5, $t6
		and $t5, $t5, $t7
		and $t5, $t5, $t8
		beq $t5, 1, skip
        jr      $ra
skip:
		lw $t2, 12 ($a3)
		mul $t3, $a0, 4
		add $t2, $t2, $t3
		lw $t2, 0 ($t2)
		add $t2, $t2, $a1
		lb $t3, 0($t2)		##t3:curr
		lb $t4, 8 ($a3)		##t4:pattern
		beq $t3, $t4, skip2
		beq $t3, $a2, skip2
		sb $a2,0($t2)
		sub $sp, $sp, 12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sub $a0, $a0, 1
		jal flood_fill
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		add $a1, $a1, 1
		jal flood_fill
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		add $a0, $a0, 1
		jal flood_fill
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		sub $a1, $a1, 1
		jal flood_fill
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $ra, 0($sp)
		add $sp, $sp, 12	
skip2:
		jr $ra
