.ifndef uart_def
	.include "uart.inc"
.endif
.ifndef regs_def
	.include "regs.inc"
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
		call	UART_receive
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
		adiw	r24, 1
		add		r26, r24		; add length for backwards load from stack
		adc		r27, r25
 pop_loop:
		ld 		r16, Y+
		st		-X, r16
		sbiw	r24, 1
		brne	pop_loop
		ret

pushx:
		adiw	Tl, 1
		add 	Xl, Tl
		adc		Xh, Th
		st 		X, zero
		st 		-X, ra
		ret

popx:
		sbiw	Tl, 1
		add 	Xl, Tl
		adc		Xh, Th
		ld		ra, X
		st		X, zero
		ret

index:
		cpi 	rj, 0
		brpl	index_end
		add		Xl, Tl
		adc		Xh,	Th
 index_end:
		add		Xl, ri
		adc		Xh,	rj
		ret

clone_string:
	; if we are copying to a smaller address, then front to back
	; otherwise back to front (this is to avoid rewriting the data that hasn't been copied yet)
		push	Yl
		push	Yh
		movw	Yl, ra
		cp		Xh, Yh
		brge	front_to_back
		cp		Xl, Yl
		brge	front_to_back

		add 	Yl, Tl
		adc		Yh, Th
		add 	Xl, Tl
		adc		Xh, Th
		st		Y, zero

back_to_front:
		ld 		ra, -X

		brtc 	skip_erase_BTF
		st 		X, zero
 skip_erase_BTF:

		st		-Y, ra
		sbiw	Tl, 1
		brne	back_to_front
		cpi		Th, 0
		brne	back_to_front
		rjmp 	clone_string_end

front_to_back:
		ld 		ra, X

		brtc 	skip_erase_FTB
		st 		X, zero
 skip_erase_FTB:
		adiw	Xl, 1 		

		st		Y+, ra
		sbiw	Tl, 1
		brne	front_to_back
		cpi		Th, 0
		brne	front_to_back

		st		Y, zero

clone_string_end:
		clt
		pop		Yh
		pop		Yl
		ret

move_string:
		set
		rcall 	clone_string
		ret

.macro load_memory
 .ifndef PM_loaded
	.def PM_loaded
load_program_memory:
		ldi		Zh, high(@0)
		ldi		Zl, low(@0)

		ldi		Th, high(@1 +1)
		ldi		Tl, low(@1 +1)
		
		ldi		Xh, 0x01
		ldi		Xl, 0x00
 lpm_loop:
		lpm 	ra, Z+
		st 		X+, ra
		sbiw	Tl
		brne	lpm_loop

		xor 	ra, ra
		ret

 .endif
.endm
