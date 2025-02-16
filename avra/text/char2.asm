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
main:
		call 	UART_init

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		movw	sava, Xl

		ldi		Tl, 0
		ldi		Th, 0

		ldi		ra, 'H'
		call	pushx

		movw	Xl, sava
		ldi		ra, 'e'
		call	pushx

		movw	Xl, sava
		ldi		ra, 'l'
		call	pushx

		movw	Xl, sava
		ldi		ra, 'a'
		call	pushx

		movw	Xl, sava
		call	popx

		movw	Xl, sava
		ldi		ra, 'l'
		call	pushx

		movw	Xl, sava
		ldi		ra, 'o'
		call	pushx

		movw	Xl, sava
		ldi		ra, 0x0d
		call	pushx

		movw	Xl, sava
		ldi		ra, 0x0a
		call	pushx

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call	UART_print

end:
		rjmp 	end		
