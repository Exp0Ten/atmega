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
index:
		add 	Xl, ri
		adc		Xh, rj
		ld 		ra, X
		ret

pushx:
		adiw	Tl, 1
		add 	Xl, Tl
		adc		Xh, Th
		st 		X, zero
		st 		-X, ra
		ret

popx:
		sbiw	Tl, 1
		add 	Xl, Tl
		adc		Xh, Th
		ld		ra, X
		st		X, zero
		ret

main:
		call 	UART_init

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call 	UART_input

		sts		len, Tl
		ldi		Th, 0
		lds		Tl, len

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		ldi		ra, 'A'
		call	pushx

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call	UART_print

end:
		rjmp 	end		
