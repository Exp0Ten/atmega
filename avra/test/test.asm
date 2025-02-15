.nolist
.include "atmega328p.inc"
.list
.include "init.inc"
.include "uart.inc"

baud 9600

	.cseg
main:
		call 	UART_init
		ldi		r16, 'A'
		call	UART_send

		ldi		r16, 'B'
		call	UART_send

end:
		rjmp 	end		
