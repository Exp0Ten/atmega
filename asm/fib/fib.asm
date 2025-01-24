.include "atmega328p.inc"

.equ count, 10

.data

A: 		.byte 1
B: 		.byte 1

.text

	.global RESET
RESET:
		ldi 	r16, 1
		sts		A, r16
		sts		B, r16
	
		rjmp main

main:
		ldi 	r16, count

fib_loop:
		rcall 	fib
		dec		r16
		brne	fib_loop
		rjmp 	end

fib:
		lds		r17, A
		lds		r18, B
		sts		B, r17
		add		r17, r18
		sts		A, r17
		
		ret

end:
		rjmp end
