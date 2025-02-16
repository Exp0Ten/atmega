.nolist
.include "atmega328p.inc"
.list

.include "init.inc"


main:
		ldi 	r19, 0xff
		out 	DDRB, r19
 loop:
 		out		PORTB, r19
 		call	delay
 		out		PORTB, r0
		call	delay

		rjmp 	loop

delay:
		ldi		r18, 0x10	; counter 1
 loop3:
 		ldi		r17, 0xff	; counter 2
 loop2:
 		ldi		r16, 0xff	; counter 3
 loop1:
 		dec		r16
		cpi		r16, 0
 		brne	loop1

 		dec		r17
		cpi		r17, 0
 		brne	loop2

 		dec		r18
		cpi		r18, 0
 		brne	loop3

 		ret
