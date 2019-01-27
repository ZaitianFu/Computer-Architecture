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
## // Draw a line on canvas from start_pos to end_pos.
## // start_pos will always be smaller than end_pos.
## void draw_line(unsigned int start_pos, unsigned int end_pos,
##                Canvas* canvas) {
##     unsigned int width = canvas->width;
##     unsigned int step_size = 1;
##     // Check if the line is vertical.
##     if (end_pos - start_pos >= width) {
##         step_size = width;
##     }
##     // Update the canvas with the new line.
##     for (int pos = start_pos; pos != end_pos + step_size;
##              pos += step_size) {
##         canvas->canvas[pos / width][pos % width] = canvas->pattern;
##     }
## }

.globl draw_line
draw_line:
        # Your code goes here :)
		lw $t0, 4($a2)		##t0:width
		li $t1,1			##t1:stepsize
		sub $t2, $a1, $a0
		blt $t2, $t0, skip1
		move $t1, $t0
	skip1:
		move $t2,$a0		##t2:pos
		add $t3, $t1, $a1	##t3:end+stepsize
	loop:		
		beq $t2, $t3, skip2
		rem $t4, $t2, $t0	##t4:pos%width
		div $t5, $t2, $t0	##t5:pos/width
		sll $t5, $t5, 2
		lb $t6, 8($a2)      ##t6:pattern
		lw $t7, 12($a2)		##t7:ca->canvas
		add $t7, $t7, $t5   ##t7:canvas+/	
		lw $t7, 0($t7)
		add $t7, $t7, $t4   ##t7:canvas+%
		sb $t6, 0($t7)		
		add $t2, $t2, $t1
		j loop
	skip2:	
        jr      $ra
