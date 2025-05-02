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
        ret
 send_binary_set:
        ldi     ra, '1'
        call    UART_send
        lsl     rd
        dec     ri
        brne    send_binary_loop
        ret
