.include "atmega328p.inc"
.include "init.inc"
.include "regs.inc"

main:
        ldi     ra, 0b100000
        out     DDRB, ra
