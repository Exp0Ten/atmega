send_binary:
        ldi     ri, 8
 send_binary_loop:
        sbrc    rd, 7
        rjmp    send_binary_set

        ldi     ra, '0'
        call    UART_send
        lsl     rd
        dec     ri
        brne    send_binary_loop
        rjmp    send_binary_end

 send_binary_set:
        ldi     ra, '1'
        call    UART_send
        lsl     rd
        dec     ri
        brne    send_binary_loop

 send_binary_end:
        ldi     ra, ' '
        call    UART_send
        ret

encode:
        ldi     Xl, low(data_buffer)
        ldi     Xh, high(data_buffer)
        ldi     Zl, low(raw_buffer)
        ldi     Zh, high(raw_buffer)
        ldi     Tl, 0x00
        ldi     Th, 0x01

 encode_loop:
        ld      ra, X+
        ld      rb, X+
        ld      rc, X
        