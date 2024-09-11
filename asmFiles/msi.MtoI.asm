org 0x0000 #I to S
ori $2, $0, 0x04
ori $3, $0, 0x69

sw $3, 40($2)

nop
nop
nop
nop
nop
nop

lw $4, 0($2)

halt

org 0x0200 
nop
nop
nop
nop
nop
ori $2, $0, 0x08
ori $3, $0, 0x69

sw $3, 40($2)
halt
