#include <avr/io.h>

.equ F_CPU, 16000000
.equ BAUD, 	9600
.equ DOUBLE_SPEED, 0

.if DOUBLE_SPEED == 1
	;.equ UBRR_VALUE, (F_CPU / (8 * BAUD)) - 1
	.equ UBRR_VALUE, 207
.else
	;.equ UBRR_VALUE, (F_CPU / (16 * BAUD)) - 1
	.equ UBRR_VALUE, 103
.endif

	.global RESET
RESET:
		cli
	.if DOUBLE_SPEED == 1
		lds		r16, UCSR0A
		ori		r16, (1 << U2X0)
		sts		UCSR0A, r16
	.else
		lds		r16, UCSR0A
		andi	r16, ((1 << U2X0) ^ 0xFF)
		sts		UCSR0A, r16		
	.endif

		ldi		r16, (UBRR_VALUE >> 8)
		sts		UBRR0H, r16
		ldi		r16, UBRR_VALUE
		sts		UBRR0L, r16

		ldi		r16, ((1 << TXEN0)|(1 << RXEN0))
		sts		UCSR0B, r16
		
		ldi		r16, ((1 << UMSEL00)|(1 << UMSEL01))
		sts		UCSR0C, r16

		rjmp 	main

send_byte:
		lds		r17, UCSR0A
		sbrs	r17, UDRE0
		rjmp 	send_byte

		sts		UDR0, r16
		ret

main:
		ldi		r16, 'A'
		rcall 	send_byte
		ldi		r16, 'A'
		rcall 	send_byte
		ldi		r16, 'A'
		rcall 	send_byte
		ldi		r16, 'A'
		rcall 	send_byte



end:
		rjmp 	end
