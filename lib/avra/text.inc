.ifndef uart_def
	.include "uart.inc"
.endif



UART_CP:		; character processing
		cpi		r16, 0x0d
		breq	CP_newline
		cpi		r16, 0x08
		breq	CP_backspace
		cpi		r16, 0x1b
		breq	CP_escape
		ldi 	r17, 0x80
		and		r17, r16	 	; if MSB is set or not (ascii only uses 7 bits)
		brne	CP_nonascii

		call	UART_send
 CP_end:
		st		X+, r16
		ret

 CP_newline:
 		call	UART_send
		st		X+, r16
		ldi		r16, 0x0a
		call	UART_send
		rjmp	CP_end

 CP_backspace:
 		cpse	r26, r24
		rjmp	CP_BS_normal
 		cp 		r27, r25
		breq	CP_BS_skip

  CP_BS_normal:
		call	UART_send
		ldi		r16, ' '
		call	UART_send
		ldi		r16, 0x08
		call	UART_send
		st		-X, r0		; remove last char from buffer

  CP_BS_skip:
		ret

 CP_nonascii:
 		ldi		r16, '.'
 		call	UART_send
 		rjmp 	CP_end		; "." will get stored in the string instead

 CP_escape:
 		ret

UART_input:
		movw	r24, r26
 UART_input_loop:
		call	UART_recieve
		call	UART_CP
		cpi		r16, 0x0a
		brne 	UART_input_loop

 UART_input_end:		; after newline
 		st		X, r0		; end of string
 		sub 	r26, r24
 		sbc		r27, r25
 		movw	r24, r26
		ret					; returns string length

push_string:
		ld 		r16, X+
		st 		-Y, r16
		cpse	r16, r0
		rjmp 	push_string
		ret

pop_string:
		add		r26, r24		; add length for backwards load from stack
		adc		r27, r25
 pop_loop:
		ld 		r16, Y+
		st		-X, r16
		sbiw	r24, 1
		brne	pop_loop
		ret
