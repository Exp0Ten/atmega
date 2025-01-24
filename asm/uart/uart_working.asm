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
		ldi		r28, 0xff
		ldi		r29, 0x08
		out		0x3D, r28	; SPL
		out		0x3E, r29	; SPH
		jmp 	main

uart_init:
		sts		0x00C0, r0

		ldi		r16, 103
		sts 	0x00C5, r0
		sts		0x00C4, r16

		ldi		r16, 8
		sts		0x00C1, r16
		ldi		r16, 6
		sts		0x00C2, r16

		ret		

uart_transmit:
		lds		r16, 0x00C0
		andi	r16, 32
		cp		r16, r0
		breq	uart_transmit	; loop if bit 5 == 0

		sts		0x00C6, r17
		ret

main:
		call 	uart_init
		ldi		r17, 0x41
		call 	uart_transmit

		jmp 	exit

exit:
;		cli
_end:
		rjmp _end
