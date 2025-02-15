.nolist
.include "atmega328p.inc"
.include "init.inc"
.equ F_CPU = 16000000
.list

.equ BAUD 	= 9600
.equ UBRR  	= (F_CPU / (16 * BAUD)) - 1

rest
		cli
		jmp 	main


UART_init:
		sts		UCSR0A, r0

		ldi		r16, UBRR >> 8
		sts		UBRR0H, r16
		ldi		r16, UBRR
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
		reti

UART_recieve:
		lds		r17, UCSR0A
		sbrs	r17, RXC0
		rjmp 	UART_recieve

		lds		r16, UDR0
		ret		

main:
		call	UART_init
loop:
		call UART_recieve
		call UART_send
		rjmp loop
end:
		rjmp	end
