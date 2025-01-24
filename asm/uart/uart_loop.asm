.include "atmega328p.inc"

.equ F_CPU, 16000000
.equ BAUD, 9600
.equ UBRR_VALUE, ((F_CPU / (16 * BAUD)) - 1)

	.section .data
.org 0x120
string:	.asciz "Hello, World!\n"

	.section .text
;.org 0
;_vectors:			;interrupt vectors
;		jmp RESET
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors
;		jmp _vectors

	.global RESET
RESET:
		cli
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

uart_print:
		movw	r26, r16
 up_loop:
		ld 		r17, X+
		cpi		r17, 0x00
		breq	up_end
		call 	uart_transmit	
		rjmp	up_loop
 up_end:
		ret

uart_print_memory:
		movw	r26, r16
 upm_loop:
		subi	r18, 1
		breq	upm_end
		ld 		r17, X+
		call 	uart_transmit	
		rjmp	upm_loop
 upm_end:
		ret


;init_memory:
;		lds		r16, char
;		ldi		r17, 'i'
;		ldi		r18, 0
;		sts		0x120, r16
;		sts		0x121, r17
;		sts		0x122, r18
;
;		ret

main:
		;call 	init_memory
		call 	uart_init
		ldi		r16, lo8(0x126)	;start
		ldi		r17, hi8(0x126)
		ldi		r18, 0xff	;size
		call	uart_print_memory
		ldi		r16, lo8(0x126)	;start
		ldi		r17, hi8(0x126)				
		call 	uart_print
				
		jmp 	exit

exit:
		cli
_end:
		rjmp _end
