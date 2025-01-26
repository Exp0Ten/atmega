.nolist
.include "atmega328p.inc"
.include "init.inc"
.list

.cseg
rest

interrupt INT0s, INT0addr
INT0s:
	ldi r16, 0xff
