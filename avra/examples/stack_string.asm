.nolist
.include "atmega328p.inc"
.list
.include "init.inc"
.include "uart.inc"
.include "text.inc"

baud 9600

	.dseg
buffer:	 .byte 64		; original input buffer
buffer2: .byte 64		; the clone of input buffer using stack cloning

	.cseg

;push_string:
;		ld 		r16, X+
;		st 		-Y, r16
;		cpse	r16, r0
;		rjmp 	push_string
;		ret
;
;pop_string:
;		add		r26, r24		; add length for backwards load from stack
;		adc		r27, r25
; pop_loop:
;		ld 		r16, Y+
;		st		-X, r16
;		sbiw	r24, 1
;		brne	pop_loop
;		ret

main:
		push 	r28
		push 	r29
		in 		r28, SPL		
		in 		r29, SPH

		movw 	r16, r28
		subi	r16, 64		; allocating memory on stack - 64 bytes
		sbci	r17, 0
		out		SPL, r16
		out		SPH, r17
		

		call	UART_init

		ldi		r26, low(buffer)
		ldi		r27, high(buffer)
		call	UART_input

		ldi		r26, low(buffer)
		ldi		r27, high(buffer)
		call	push_string

		ldi		r26, low(buffer2)
		ldi		r27, high(buffer2)
		call	pop_string		

		ldi		r26, low(buffer2)
		ldi		r27, high(buffer2)
		call	UART_print

		out		SPH, r29
		out		SPL, r28
		pop 	r29
		pop 	r28

end:
		rjmp 	end
