.include "atmega328p.inc"

.equ F_CPU, 16000000
.equ BAUD, 9600
.equ UBRR_VALUE, ((F_CPU / (16 * BAUD)) - 1)

_vectors:			;interrupt vectors
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

	.global RESET
RESET:
		eor 	r0, r0
		out 	0x3f, r0	; reset SREG
		ldi		r28, (RAMEND & 0xff)
		ldi		r29, (RAMEND >> 8)
		out		0x3d, r28	; SPL
		out		0x3e, r29	; SPH
		jmp 	main

uart_init:
		sts		UCSR0A, r0

		ldi		r16, (UBRR_VALUE & 0xff)
		ldi		r18, (UBRR_VALUE >> 8)
		sts 	UBRR0H, r18
		sts		UBRR0L, r16

		ldi		r16, (1 << TXEN0)
		sts		UCSR0B, r16
		ldi		r16, ((1 << UCSZ01) | (1 << UCSZ00))
		sts		UCSR0C, r16

		ret		

uart_transmit:
		lds		r16, UCSR0A
		andi	r16, (1 << UDRE0)
		cp		r16, r0
		breq	uart_transmit	; loop if bit 5 == 0

		sts		UDR0, r17
		ret

main:
		call 	uart_init
		ldi		r17, 'A'
		call 	uart_transmit

		jmp 	exit

exit:
;		cli
_end:
		rjmp _end
