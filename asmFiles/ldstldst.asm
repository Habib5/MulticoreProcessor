org 0x0000

lw $2, 0x8000($0)
sw $2, 0x4000($2)
lw $3, 0x8004($2)
sw $2, 0x4004($3)
halt

org 0x8000
cfw 0x8000
cfw 0x0024
cfw 0x0408

