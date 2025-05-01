step:
		; save ra
		push	ra

		; STEPP to LOW
		cbi		PORTD, STEPP
		; wait 	1us == 8 + 2*4 cycles == 16 cycles
		ldi		Tl, 2
		call	wait_short

		; STEPP to HIGH (triggers the step of the head)
		sbi		PORTD, STEPP
		; wait for 3ms = 64*750 = 48000 cycles
		ldi		Th, 0x02
		ldi		Tl, 0xee
		ldi		rs, 0b1011 	; 64 prescaler
		call	wait_long

		pop		ra
		ret


dir_plus:
		; Dir to LOW == TO INNER TRACKS
		cbi		PORTD, Dir
		ret


dir_minus:
		; Dir to HIGH == TO OUTER TRACKS
		sbi		PORTD, Dir
		ret


trackzz:
		rcall	dir_minus

 trackzz_loop:
		; wait 2.8ms == 256*175 == 44800 cycles		
		ldi		Tl, 175
		ldi		rs, 0b100 ; 256 prescaler
		rcall	wait

		sbis	PINB, TR00
		rjmp	trackzz_end

		rcall	step
		rjmp	trackzz_loop

 trackzz_end:
		sts 	track_number, zero
		ret


motor_start:
		sbi 	
