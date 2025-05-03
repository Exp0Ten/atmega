.nolist
.include "atmega328p.inc"
.include "init.inc"
.include "uart.inc"
.include "regs.inc"
.include "misc.inc"
.list

.include "setup.asm"

.include "data.asm"
.include "seek.asm"
.include "write.asm"
.include "read.asm"


main:
		call 	setup

		ldi		Zl, low(start_msg*2)
		ldi		Zh, high(start_msg*2)
		call	UART_printZ
        cbi     PORTB, LED

main_loop:
		call	wait_for_disk

		; wait 0.5s, just for protection
		ldi		Th,	0x1e
		ldi		Tl, 0x84
		ldi		rs, 0b1101
		call	wait_long

		call	test_wp
		brts	main_loop

		call	trackzz

        sbi     PORTB, LED

        call    motor_start

        ldi     rc, 4
read_loop:
		call	read_begin

        ldi     rj, 32
        ldi     Xl, low(raw_buffer)
        ldi     Xh, high(raw_buffer)

bin_loop:
        ld      rd, X+
        call    send_binary
        dec     rj
        brne    bin_loop

        ldi     ra, 0x0d
        call    UART_send

        ldi     ra, 0x0a
        call    UART_send

        dec     rc
        brne    read_loop

        call    motor_stop

		rjmp 	end

op_loop:
		ldi		Zl, low(op_msg*2)
		ldi		Zh, high(op_msg*2)
		call	UART_printZ

		call	UART_receive
		cpi		ra,	0x0d
		breq	op_step
		cpi		ra, '+'
		breq	op_dir_plus
		cpi		ra, '-'
		breq	op_dir_minus
		cpi		ra,	'r'
		breq	op_reset
		cpi		ra,	'm'
		breq	op_motor_start
		cpi		ra,	'n'
		breq	op_motor_stop


		ldi		Zl, low(err_msg*2)
		ldi		Zh, high(err_msg*2)
		call	UART_printZ
		rjmp 	op_loop

op_step:
		call	step
		rjmp	op_loop
op_dir_plus:
		call	dir_plus
		rjmp	op_loop
op_dir_minus:
		call	dir_minus
		rjmp	op_loop
op_reset:
		call	trackzz
		rjmp	op_loop
op_motor_start:
		call	motor_start
        call    wait_for_index
		rjmp 	op_loop
op_motor_stop:
		call	motor_stop
		rjmp 	op_loop

end:
		rjmp 	end


op_msg: .db "OP:", 0x0d, 0x0a, 0x00
err_msg: .db "err", 0x0d, 0x0a, 0x00
start_msg: .db "Program loaded.", 0x0d, 0x0a, 0x00

    .dseg

track_number: .byte 1

raw_buffer: .byte 1024
