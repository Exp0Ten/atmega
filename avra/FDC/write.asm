write_begin:
        ldi     rc, 0
        sbi     PORTC, WRITE

        cbi     PORTB, WRGT
        ldi     Tl, 30
        call    wait_short
        call    wait_for_index
        rcall   write_raw

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


write_raw:
        call    wn  ; 0
        call    wn
        call    wt  ; 1
        call    wn
        call    wt  ; 1
        call    wn
        call    wn  ; 0
        call    wt
        call    wn  ; 0
        call    wt
        call    wn  ; 0
        call    wt
        call    wn  ; 0
        call    wn
        call    wt  ; 1
        call    wnh         ; 8 cycles

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