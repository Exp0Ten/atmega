.nolist
.include "atmega328p.inc"
.list
.include "init.inc"
.include "uart.inc"

baud 9600


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
 		cpse	r26, r14
		rjmp	CP_BS_normal
 		cp 		r27, r15
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
		movw	r14, r26
 UART_input_loop:
		call	UART_receive
		call	UART_CP
		cpi		r16, 0x0a
		brne 	UART_input_loop
 UART_input_end:		; after newline
 		st		X, r0		;end of string
		ret

main:
		call	UART_init
		
		ldi		r26, low(buffer)
		ldi		r27, high(buffer)
		call	UART_input
		ldi		r26, low(buffer)
		ldi		r27, high(buffer)
		call	UART_print
end:
		rjmp 	end

	.dseg
buffer: .byte 1
