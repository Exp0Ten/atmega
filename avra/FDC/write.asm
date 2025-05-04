write_begin:
        ldi     rc, 32
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

