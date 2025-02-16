.nolist
.include "atmega328p.inc"
.list
.include "init.inc"
.include "uart.inc"
.include "regs.inc"
.include "text.inc"

baud 9600

	.cseg
main:
		call 	UART_init
loop:
		call 	UART_input

		ldi		ra, 'A'
		call	UART_send

;		ldi		r16, 'B'
;		call	UART_send

		rjmp 	loop
