read_begin:
        ldi     Th, 0x00
        ldi     Tl, 0x20        ; 256byte
        mov     sava, Tl        ; saving Tl
        ldi     Xl, low(raw_buffer)
        ldi     Xh, high(raw_buffer)
        call    wait_for_index
 read_offset:     ; nop offsets (1 nop = 0.0625 us)

        rcall   read_raw    ; +3 cycles

        ret

 read_raw_end:
 		ret

read_raw:
        clr     rd
 bit0:
		sbic	PINC, READ
		rjmp	bit0_end

  set_bit0:
 		sbr		rd, 0b1

  bit0_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        subi     Tl, 1
        breq    read_raw_end
        nop
        nop
        nop


 bit1:
		sbic	PINC, READ
		rjmp	bit1_end

  set_bit1:
 		sbr		rd, 0b10

  bit1_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        nop
        nop
        nop
        nop
        nop


 bit2:
		sbic	PINC, READ
		rjmp	bit2_end

  set_bit2:
 		sbr		rd, 0b100

  bit2_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        nop
        nop
        nop
        nop
        nop


 bit3:
		sbic	PINC, READ
		rjmp	bit3_end

  set_bit3:
 		sbr		rd, 0b1000

  bit3_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        nop
        nop
        nop
        nop
        nop


 bit4:
		sbic	PINC, READ
		rjmp	bit4_end

  set_bit4:
 		sbr		rd, 0b10000

  bit4_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        nop
        nop
        nop
        nop
        nop


 bit5:
		sbic	PINC, READ
		rjmp	bit5_end

  set_bit5:
 		sbr		rd, 0b100000

  bit5_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        nop
        nop
        nop
        nop
        nop


 bit6:
		sbic	PINC, READ
		rjmp	bit6_end

  set_bit6:
 		sbr		rd, 0b1000000

  bit6_end: ; 3+13 cycles
; 		ldi		Tl, 1 ; 1
; 		call	wait_short ; 12
        nop
        nop
        nop
        nop
        nop


 bit7:
		sbic	PINC, READ
		rjmp	bit7_end

  set_bit7:
 		sbr		rd, 0b10000000

 bit7_end:


 byte_store: ; 13 cycles
 		st		X+, rd ; 2
; 		clr		rd ; 1
;        mov     Tl, sava ; 1
;		subi 	Tl, 1 ; 1
;       mov     sava, Tl ; 1
;		nop		; 1
;		nop		; 1
;		nop		; 1
;		nop		; 1
;		brne	read_raw ; 2
;		brne	temp_jump ; 2
        rjmp    read_raw

