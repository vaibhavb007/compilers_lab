main:
#return address stored on the stack
addi $sp, $sp, -4
sw $ra, 0($sp)
#dynamic link set up
addi $sp, $sp, -4
sw $fp, 0($sp)
#set base of new activation record
move $fp, $sp
#make space for locals on stack
addi $sp, $sp, -8
#gencode for Identifier a called
addi $s1, $fp, -4
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 4 on stack
li $s0, 4
addi $sp, $sp, -4
sw $s0, 0($sp)
#assignment begins
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
addi $sp, $sp, -4
sw $s1, 0($s0)
#assignment ends
#gencode for Identifier b called
addi $s1, $fp, -8
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 5 on stack
li $s0, 5
addi $sp, $sp, -4
sw $s0, 0($sp)
#assignment begins
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
addi $sp, $sp, -4
sw $s1, 0($s0)
#assignment ends
#gencode for Identifier a called
addi $s1, $fp, -4
addi $sp, $sp, -4
sw $s1, 0($sp)
#gencode for Identifier a called
lw $s1,-4($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
#gencode for Identifier b called
lw $s1,-8($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
#code for operators generated MULT-INT
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
mul $s0, $s0, $s1
addi $sp, $sp, -4
sw $s0, 0($sp)
#assignment begins
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
addi $sp, $sp, -4
sw $s1, 0($s0)
#assignment ends
#begin of for
#gencode for Identifier a called
addi $s1, $fp, -4
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 0 on stack
li $s0, 0
addi $sp, $sp, -4
sw $s0, 0($sp)
#assignment begins
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
addi $sp, $sp, -4
sw $s1, 0($s0)
#assignment ends
L0:
#gencode for Identifier a called
lw $s1,-4($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 5 on stack
li $s0, 5
addi $sp, $sp, -4
sw $s0, 0($sp)
#code for operators generated LT-INT
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
slt $s0, $s0, $s1
addi $sp, $sp, -4
sw $s0, 0($sp)
lw $s1, 0($sp)
addi $sp, $sp, 4
beq $s1, $0, L1
#make space for locals on stack
addi $sp, $sp, -0
#gencode for Identifier b called
addi $s1, $fp, -8
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 1 on stack
li $s0, 1
addi $sp, $sp, -4
sw $s0, 0($sp)
#assignment begins
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
addi $sp, $sp, -4
sw $s1, 0($s0)
#assignment ends
#gencode for Identifier a called
addi $s1, $fp, -4
addi $sp, $sp, -4
sw $s1, 0($sp)
#gencode for Identifier a called
lw $s1,-4($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 1 on stack
li $s0, 1
addi $sp, $sp, -4
sw $s0, 0($sp)
#code for operators generated PLUS-INT
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
add $s0, $s0, $s1
addi $sp, $sp, -4
sw $s0, 0($sp)
#assignment begins
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
addi $sp, $sp, -4
sw $s1, 0($s0)
#assignment ends
j L0
L1:
#end of for
#set base pointer to activation record of calling function
move $sp, $fp
lw $fp, 0($fp)
addi $sp, $sp, 4
#return to caller
lw $ra, 0($sp)
addi $sp, $sp, 8
jr $ra
