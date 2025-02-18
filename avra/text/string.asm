.nolist
.include "atmega328p.inc"
.list

.include "init.inc"
.include "regs.inc"
.include "text.inc"

baud 9600

	.dseg
buffer_copy: .byte 128
len_copy: .byte 2
buffer: .byte 128
len: .byte 2

	.cseg

;index:
;		brtc	index_end 		; when using negative index, set the T flag
;		add		Xl, Tl
;		adc		Xh,	Th
; index_end:
;		add		Xl, ri
;		adc		Xh,	rj
;		ret

;clone_string:
;	; if we are copying to a smaller address, then front to back
;	; otherwise back to front (this is to avoid rewriting the data that hasn't been copied yet)
;		push	Yl
;		push	Yh
;		movw	Yl, ra
;		cp		Xh, Yh
;		brge	front_to_back
;		cp		Xl, Yl
;		brge	front_to_back
;
;		add 	Yl, Tl
;		adc		Yh, Th
;		add 	Xl, Tl
;		adc		Xh, Th
;		st		Y, zero
;
;back_to_front:
;		ld 		ra, -X
;
;		brtc 	skip_erase_BTF
;		st 		X, zero
; skip_erase_BTF:
;
;		st		-Y, ra
;		sbiw	Tl, 1
;		brne	back_to_front
;		cpi		Th, 0
;		brne	back_to_front
;		rjmp 	clone_string_end
;
;front_to_back:
;		ld 		ra, X
;
;		brtc 	skip_erase_FTB
;		st 		X, zero
; skip_erase_FTB:
;		adiw	Xl, 1 		
;
;		st		Y+, ra
;		sbiw	Tl, 1
;		brne	front_to_back
;		cpi		Th, 0
;		brne	front_to_back
;
;		st		Y, zero
;
;clone_string_end:
;		clt
;		pop		Yh
;		pop		Yl
;		ret
;
;move_string:
;		set
;		rcall 	clone_string
;		ret

;insertx:
		


main:
		call 	UART_init

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call 	UART_input

;		sts 	len, Tl
;		sts 	len+1, Th

		ldi		ra, low(buffer_copy)
		ldi		rb, high(buffer_copy)
		movw	sava, ra
		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call	move_string

		ldi		ra, 'A'
		call	UART_send

		movw	Xl, sava
		call	UART_print

		ldi		ra, 'B'
		call	UART_send

		ldi		Xl, low(buffer)
		ldi		Xh, high(buffer)
		call	UART_print


end:
		rjmp 	end
