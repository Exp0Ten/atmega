write_begin:
        ldi     rc, 64
        sbi     PORTC, WRITE

        cbi     PORTB, WRGT
        ldi     Tl, 30
        call    wait_short
        call    wait_for_index
        rcall   a1_sync
;        rcall   write_raw

        ret

wt: ; 16
        cbi     PORTC, WRITE
        nop
        nop
        nop
        nop
        sbi     PORTC, WRITE
        ret



wn: ; 16
        call    wnh
 wnh:
        ret

a1_sync:
        call    wt
        call    wn
        call    wn
        call    wn
        call    wt
        call    wn
        call    wn
        call    wt
        call    wn
        call    wn
        call    wn
        call    wt
        call    wn
        call    wn
        call    wt
        call    wn

write_raw:
        call    wn
        call    wn
        call    wt
        call    wn
        call    wt
        call    wn
        call    wn
        call    wt
        call    wn
        call    wt
        call    wn
        call    wt
        call    wn
        call    wn
        call    wt

        call    wnh

        nop
        nop
        nop
        nop

        nop
        dec     rc
        brne    write_raw

        sbi     PORTC, WRITE
        sbi     PORTB, WRGT

        ret

write_bytes:
        sbi     PORTC, WRITE
        ldi     Xl, low(raw_buffer)
        ldi     Xh, high(raw_buffer)
        ld      rd, X+
        ldi     ri, 8
        ldi     rio, 0b1101

        cbi     PORTB, WRGT
        ldi     Tl, 30
        call    wait_short
        ldi     Tl, 0x00
        ldi     Th, 0x04
        call    wait_for_index

 write_continue: ; 11 + 5
        nop
        nop
        nop
        nop
        nop
        nop
        nop

 write_loop:
        sbrc    rd, 7           ; 1/2
        out     PORTC, rio      ; 1
        lsl     rd              ; 1
        nop                     ; 1
        nop                     ; 1
        nop                     ; 1
        sbi     PORTC, WRITE    ; 2
        dec     ri              ; 1
        brne    write_continue  ; 1/2

        ld      rd, X+          ; 2
        sbiw    Tl, 1           ; 2
        brne    write_loop      ; 2

        sbi     PORTC, WRITE
        ret