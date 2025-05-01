.nolist
.include "atmega328p.inc"
.list
.include "init.inc"
.include "uart.inc"
.include "regs.inc"
;.include "text.inc"
.include "misc.inc"
.list

baud 9600

	.cseg

main:
		cli
		call	UART_init
		sbi 	DDRB, PORTB5
		ldi		Th,	0x1e
		ldi		Tl, 0x84
		ldi		rs, 0b1101

loop:
		sbi 	PORTB, PORTB5
;		lds		ra, TCNT1L
;		call	UART_send
;		lds		ra, TCNT1H
;		call	UART_send
;		eor		ra, ra
		rcall	wait_long
		cbi 	PORTB, PORTB5
		rcall	wait_long
		rjmp 	loop

				

;wait:
;		ldi		ra, 0x0d
;		sts		OCR1AL, ra
;		ldi		ra, 0x03
;		sts		OCR1AH, ra
;		ldi		ra, 0b11000000
;		sts		TCCR1A, ra
;		ldi		ra, 0b1101
;		sts		TCCR1B, ra
;
;wloop:
;		sbis	TIFR1, OCF1A
;		rjmp 	wloop
;
;		sbi 	TIFR1, OCF1A
;		ret
;
;
