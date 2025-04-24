.nolist
.ifndef uart_def
	.define uart_def
.else
	.error "Multiple includes of 'uart.inc'"
.endif

.ifndef F_CPU
	.equ F_CPU = 16000000	
.endif

.ifndef U2X
	.set U2X = 0 
.endif

.macro baud
	.set BAUD = @0
	.if U2X == 1
		.set UBRRval = (F_CPU / (8 * BAUD)) - 1
	.else
		.set UBRRval = (F_CPU / (16 * BAUD)) - 1
	.endif
.endm
.list

	.cseg
UART_init:
		lds		r16, UCSR0A
	.if U2X == 1
		ori		r16, 1 << U2X0
	.else
		andi	r16, 0xff ^ (1 << U2X0)
	.endif		
		sts		UCSR0A, r16

		ldi		r16, UBRRval >> 8
		sts		UBRR0H, r16
		ldi		r16, UBRRval
		sts		UBRR0L, r16

		ldi		r16, (1 << TXEN0) | (1 << RXEN0)
		sts		UCSR0B, r16
		
		ldi		r16, (1 << UCSZ00) | (1 << UCSZ01)
		sts		UCSR0C, r16

		ret

UART_stop:
		sts		UCSR0B, r0
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

UART_receive:
		lds		r17, UCSR0A
		sbrs	r17, RXC0
		rjmp 	UART_receive

		lds		r16, UDR0
		ret		

; Print from Flash memory

UART_printZ:
		lpm		r16, Z+
		cpi		r16, 0
		breq	UART_printZ_end
		rcall	UART_send
		rjmp 	UART_printZ
 UART_printZ_end:
		ret

