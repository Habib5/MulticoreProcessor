ORG 0x0000
  lui   $10, 0xFEED
  ori   $1, $zero, 0x0F00
  ori   $2, $zero, 0x0800
  bne $1, $2, skipping
   ori   $10, $10, 0xBEEF

skipping:
   halt
