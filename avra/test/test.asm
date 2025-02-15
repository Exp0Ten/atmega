.nolist
.include "atmega328p.inc"
.list

	.cseg
	.org 0x00
_vectors:
		jmp 	RESET

	.org 0x36
RESET:
		cli
		eor 	r0, r0
		out		SREG, r0
		ldi		r28, low(RAMEND)
		ldi		r29, high(RAMEND)
		out		SPL, r28
		out		SPH, r29
		call 	main

.include "uart.inc"
baud 4800

	.cseg
main:
		call 	UART_init
		ldi		r16, 'A'
loop:
		call	UART_send
		rjmp	loop



