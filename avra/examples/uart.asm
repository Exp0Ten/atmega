.nolist
.include "atmega328p.inc"
.list
.equ F_CPU = 16000000

.equ BAUD 	 = 9600
.equ UBRRval = ((F_CPU / (16 * BAUD)) - 1)

	.cseg
	.org 0
_vectors:
		jmp RESET
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors
		jmp _vectors

	.org 0x40
RESET:
		cli
		eor 	r0, r0
		out		SREG, r0
		ldi		r28, low(RAMEND)
		ldi		r29, high(RAMEND)
		out		SPL, r28
		out		SPH, r29
		jmp 	main

UART_init:
		sts		UCSR0A, r0

 		ldi		r16, (UBRRval >> 8)
 		sts		UBRR0H, r16
 		ldi		r16, (UBRRval & 0xff)
 		sts		UBRR0L, r16

		ldi		r16, (1 << TXEN0) | (1 << RXEN0)
		sts		UCSR0B, r16
		
		ldi		r16, (1 << UCSZ00) | (1 << UCSZ01)
		sts		UCSR0C, r16

		ret

UART_send:
		lds		r17, UCSR0A
		sbrs	r17, UDRE0
		rjmp 	UART_send

		sts		UDR0, r16
		ret

UART_print:
		ld		r16, X+
		cpi		r16, 0
		breq	UART_print_end
		rcall	UART_send
		rjmp 	UART_print
 UART_print_end:
		ret

UART_recieve:
		lds		r17, UCSR0A
		sbrs	r17, RXC0
		rjmp 	UART_recieve

		lds		r16, UDR0
		ret		

main:
		call	UART_init
loop:
		call 	UART_recieve
		call 	UART_send
		rjmp	main
