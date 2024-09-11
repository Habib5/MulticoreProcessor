org 0x0000 #I to M
ori $2, $0, 0x04
ori $3, $0, 0x69

sw $3, 0($2)

nop
nop
nop
nop
nop
nop

sw $4, 0($2)

halt

org 0x0200 
nop
nop
nop
nop
nop
ori $2, $0, 0x08
ori $3, $0, 0x69

sw $3, 0($2)
halt
