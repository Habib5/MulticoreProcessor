org 0x0000
ori $1, $0, 0xF0
ori $2, $0, 0xAAAA
ori $3, $0, 0xBBBB
ori $7, $0, 0xFFCC
nop
nop
nop
nop
addi $7, $7, -4
sw  $3, 0($1)
addi $7, $7, -4
sw  $4, 4($1)
nop
nop
nop
nop
nop
sw  $7, 8($1)
halt
