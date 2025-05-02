.nolist
.ifndef regs_def
	.include "regs.inc"
.endif
.list


wait:
        out     OCR0A, Tl
        ldi     ra, 0b11000010
        out     TCCR0A, ra
        out     TCCR0B, rs

wait_loop:
        sbis    TIFR0, OCF0A
        rjmp    wait_loop

        out     TCCR0B, zero
        sbi     TIFR0, OCF0A
        out     TCNT0, zero
        out     TCCR0A, zero
        ret


wait_long:
        sts     OCR1AL, Tl
        sts     OCR1AH, Th
        ldi     ra, 0b11000000
        sts     TCCR1A, ra
        sts     TCCR1B, rs

wait_long_loop:
        sbis    TIFR1, OCF1A
        rjmp    wait_long_loop

        sts     TCCR1B, zero
        sbi     TIFR1, OCF1A
;        sts     TCNT1H, zero
;        sts     TCNT1L, zero
        sts     TCCR1A, zero
        ret

wait_short:
        ; 4 per 1 in Tl, +8, call always with CALL, min == 12, max == 264
        dec     Tl
        nop
        brne    wait_short
        nop
        ret