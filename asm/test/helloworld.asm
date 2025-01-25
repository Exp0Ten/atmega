#include <avr/io.h>

	.global RESET					; ENTRY
RESET:
		ser		r16					; => ldi r16, 0xff
		out		_SFR_IO_ADDR(DDRB), r16			; PORTB => output

		ldi		r16, 0b0101 		; CS02 and CS01 bit set => 1024 prescaler
       	out	 	_SFR_IO_ADDR(TCCR0B), r16

		rjmp 	main_loop

main_loop:
		sbi		_SFR_IO_ADDR(PORTB), PORTB5 		; turn LED on
		rcall	WOS 				; wait one second
		cbi		_SFR_IO_ADDR(PORTB), PORTB5		; turn LED off
		rcall	WOS 				; wait one second
		rjmp	main_loop

WOS:
		ldi		r16, 61	

WOS_loop:
		sbis	_SFR_IO_ADDR(TIFR0), TOV0			; test the overflow flag, skips loop if true (=> 1 cycle)
		rjmp	WOS_loop

		sbi 	_SFR_IO_ADDR(TIFR0), TOV0			; clearing the interrupt flag for the next cycle
		
		dec		r16					; counting from 61 to zero (with 1024 prescaler => 1 second)
		brne	WOS_loop

		ret
