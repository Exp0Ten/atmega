.nolist
.include "atmega328p.inc"
.list

.include "init.inc"
.include "regs.inc"
.include "text.inc"

baud 9600

	.dseg
.byte 1
buffer: .byte 128
len: .byte 1

	.cseg
;pushx:
;		adiw	Tl, 1
;		add 	Xl, Tl
;		adc		Xh, Th
;		st 		X, zero
;		st 		-X, ra
;		ret
;
;popx:
;		sbiw	Tl, 1
;		add 	Xl, Tl
;		adc		Xh, Th
;		ld		ra, X
;		st		X, zero
;		ret


main:
		call 	UART_init

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		movw	sava, Xl
		call	UART_input

		sts 	len, Tl

		movw	Xl, sava
		call	popx
		push	ra

		movw	Xl, sava
		call	popx
		push	ra

		movw	Xl, sava
		ldi		ra, 'A'
		call	pushx

		movw	Xl, sava
		pop 	ra
		call	pushx

		movw	Xl, sava
		pop 	ra
		call	pushx

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call	UART_print

end:
		rjmp 	end		
