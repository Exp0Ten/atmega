.include "atmega328p.inc"

	.global RESET
RESET:
		ldi		r16, 0xff
		out		DDRB, r16

		sbi		PORTB, PORTB5
		rjmp main

main:
		
loop:
		rjmp loop
