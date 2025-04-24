.nolist
.include "atmega328p.inc"
.list
;.include "init.inc"
;.include "uart.inc"
.include "regs.inc"
;.include "text.inc"



	.cseg
main:
		ldi		ra, 0b00100000		
		out		DDRB, ra

loop:
		in 		ra, PINB
		andi	ra, (1 << PINB0)
		bst		ra, PORTB0
		clr		ra
		bld		ra, PORTB5
		out 	PORTB, ra

		rjmp 	loop

end:
		rjmp 	end

