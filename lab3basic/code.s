.data:
str0: .asciiz "yolo"
str1: .asciiz "Hello, World"
.data:
str0: .asciiz "yolo"
str1: .asciiz "Hello, World"
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
sw $s1, 0($sp)
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
sw $s1, 0($sp)
sw $s1, 0($s0)
#assignment ends
la, $s0, str0
addi $sp, $sp, -4
sw $s0, 0($sp)
#gencode for Identifier b called
lw $s1,-8($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
#gencode for Identifier a called
lw $s1,-4($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
la, $s0, str1
addi $sp, $sp, -4
sw $s0, 0($sp)
add $sp, $sp, 4
lw $a0, -4($sp)
li $v0, 4
syscall
add $sp, $sp, 4
lw $s1, -4($sp)
move $a0, $s1
li $v0, 1
syscall
add $sp, $sp, 4
lw $s1, -4($sp)
move $a0, $s1
li $v0, 1
syscall
add $sp, $sp, 4
lw $a0, -4($sp)
li $v0, 4
syscall
#set base pointer to activation record of calling function
move $sp, $fp
lw $fp, 0($fp)
addi $sp, $sp, 4
#return to caller
lw $ra, 0($sp)
addi $sp, $sp, 8
jr $ra
