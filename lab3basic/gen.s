main:
addi $s1, $fp, -4
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 4 on stack
li $s0, 4
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
sw $s1, 0($s0)
addi $s1, $fp, -8
addi $sp, $sp, -4
sw $s1, 0($sp)
#pushing 5 on stack
li $s0, 5
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
sw $s1, 0($s0)
addi $s1, $fp, -4
addi $sp, $sp, -4
sw $s1, 0($sp)
lw $s1,-4($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
lw $s1,-8($fp)
addi $sp, $sp, -4
sw $s1, 0($sp)
addi $sp, $sp, 8
lw $s0, -4($sp)
lw $s1, -8($sp)
sw $s1, 0($s0)
jr $ra
