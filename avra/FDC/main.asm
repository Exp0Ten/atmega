.include "atmega328p.inc"
.include "init.inc"
.include "uart.inc"
.include "regs.inc"
.include "misc.inc"
.include "setup.asm"

.include "data.asm"
.include "seek.asm"
.include "write.asm"
.include "read.asm"


main:
		call 	setup

		ldi		ra, '.'
		call	UART_send
;		cbi		PORTB, LED

wait_for_disk:
		sbis	PINB, WRPT
		rjmp	wait_for_disk

		; wait 0.5s, just for protection
		ldi		Th,	0x1e
		ldi		Tl, 0x84
		ldi		rs, 0b1101
		call	wait_long

		call	trackzz

		


		ldi		ra, 'e'
		call	UART_send

end:
		rjmp 	end


;wp_msg: .db "Disk is write protected.", 0xd, 0xa, 0x00

    .dseg

track_number: .byte 1
