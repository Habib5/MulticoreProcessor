ORG 0x0000

# ori $2, $0, 4
# ori $3, $0, 0xF0 #addr 1
lw $4, 0($0)
addi $3, $4, 4
nop
nop
nop
nop
nop

sw $4, 200($0) 
halt
cfw   0x0005


