# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

PRINT_INT_ADDR          = 0xffff0080
PRINT_FLOAT_ADDR        = 0xffff0084
PRINT_HEX_ADDR          = 0xffff0088

ASTEROID_MAP            = 0xffff0050
COLLECT_ASTEROID        = 0xffff00c8

STATION_LOC             = 0xffff0054
DROPOFF_ASTEROIDS       = 0xffff005c

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

STATION_ENTER_INT_MASK  = 0x400
STATION_ENTER_ACK       = 0xffff0058

STATION_EXIT_INT_MASK   = 0x2000
STATION_EXIT_ACK        = 0xffff0064


.data
# put your data things here

.align 2
asteroid_map: .space 1024

.text
main:
 # put your code here :)	
find:
	la $t0, asteroid_map
	sw $t0, ASTEROID_MAP	#t0 map
	li $t3, 10
	sw $t3,VELOCITY
	li $t1, 0
	sw $t1,ANGLE
	li $t2,1
	sw $t2,ANGLE_CONTROL 
	lw $t5, 0($t0)
	mul $t6, $t5, 8
	sub $t6, $t6,4
	add $t5, $t0, $t6
	lw $t5,0 ($t5)
	and $t6, $t5, 0xFFFF0000	#targetx
	srl $t6, $t6, 16
	and $t7, $t5, 0x0000FFFF	#targety
	li $t8,0
movey:
	lw $t3,BOT_X 
	bgt $t3,150, keep
	li $t5, 0
	sw $t5,ANGLE
	li $t5,1
	sw $t5,ANGLE_CONTROL
	li $t3, 10
	sw $t3,VELOCITY
keep:
	lw $t4,BOT_Y
	beq $t4, $t7, movex
	bgt $t4, $t7, down
	
	li $t5, 90
	sw $t5,ANGLE
	li $t5,1
	sw $t5,ANGLE_CONTROL
	j movey
down:
	li $t3, 10
	sw $t3,VELOCITY
	li $t5, 270
	sw $t5,ANGLE
	li $t5,1
	sw $t5,ANGLE_CONTROL
	j movey
movex:
	lw $t3,BOT_X
	blt $t3, 45, right
	beq $t3, $t6, eat                  	
	bgt $t3, $t6, left
right:
	li $t3, 10
	sw $t3,VELOCITY
	li $t5, 0
	sw $t5,ANGLE
	li $t5,1
	sw $t5,ANGLE_CONTROL
	j movex
left:
	li $t5,1
	sw $t5,ANGLE_CONTROL 
	li $t5, 180
	sw $t5,ANGLE
	li $t4, 10
	lw $t3,BOT_X 
	div $t3, $t3,60
	sub $t3, $t3,5
	add $t4,$t4,$t3
	sw $t4,VELOCITY
	j movex
eat:
	lw $t4, GET_CARGO
	beq $t8, 1, wait
	li $t4,1
	sw $t4, COLLECT_ASTEROID
	li $t4, 10
	sw $t4,VELOCITY
	li $t2,1
	sw $t2,ANGLE_CONTROL 
	li $t1, 0
	sw $t1,ANGLE
	lw $t3,BOT_X 
	blt $t3, 100, eat
	lw $t4, GET_CARGO
	blt $t4, 60, find
	li $t6, 285
	li $t7, 200
	li $t8,1
	j movey
wait:
	sw $0,STATION_ENTER_ACK
	sw $0, DROPOFF_ASTEROIDS
	lw $t3,BOT_X
	div $t3, $t3, 60
	li $t4,5
	sub $t3, $t4, $t3
	sw $t3,VELOCITY
	li $t5, 0
	sw $t5,ANGLE
	li $t5,1
	sw $t5,ANGLE_CONTROL
	j wait

        # note that we infinite loop to avoid stopping the simulation early
        j       main
