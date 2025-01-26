.nolist
.include "atmega328p.inc"
.include "init.inc"
.list

	.cseg
interrupt RESET, 0x00

	.org 0x22
RESET:
		cli
		ldi 	r16, 10
		rjmp 	end

end:
		rjmp end

interrupt INT1r, INT1addr
INT1r:
		ldi 	r16, 11
		ret
