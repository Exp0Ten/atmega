.nolist
.include "atmega328p.inc"
.include "init.inc"
.include "uart.inc"
.include "regs.inc"
.list

baud 9600

	.cseg

.set DS		= 2
.set Dr0	= 3
.set Dr1	= 4
.set MT		= 5
.set Dir 	= 6
.set STP	= 7

.set WG		= 0
.set T0		= 1
.set WP		= 2
.set Side	= 3
.set LED	= 4

.set RE		= 0
.set WR 	= 1
.set ID		= 2
.set DC		= 3

main:
		rcall 	UART_init

		; Setting up portD

		; D0 and D1 - RX/TX		0, 1 	null
		; D2 - Density Select	2		1
		; D3 - Drive Select0	3		5
		; D4 - Drive Select1	4		6
		; D5 - Motor On			5		7
		; D6 - Direction Select	6		8
		; D7 - Step				7		9

		ldi		ra, 0b11111100
		out		DDRD, ra

		; Setting up portB

		; B0 - Write Gate		8		12
		; B1 - Track 00			9		13
		; B2 - Write Protect	10		14
		; B3 - Side Select		12		16		

		ldi		ra, 0b1001
		out		DDRB, ra

		; Setting up portC
		
		; C0 - Read Data		A0		15
		; C1 - Write Data		A1		11
		; C2 - Index			A2		4
		; C3 - Disk Change		A3		17

		ldi		ra, 0b0010
		out		DDRC, ra

		; DRIVE SELECT, DENSITY SELECT
		ldi		ra, 0b11100000
		out		PORTD, ra

		; SIDE SELECT NORMAL
		ldi		ra, 0b1001
		out		PORTB, ra

		; WRITE DATA STANDBY
		ldi		ra, 0b0010
		out		PORTC, ra

		eor		ra, ra


test:
		; BEGIN
		ldi		Zl, low(start *2)		
		ldi		Zh, high(start *2)
		call	UART_printZ
		call	UART_receive
		ldi		Zl, low(dot *2)		
		ldi		Zh, high(dot *2)
		call	UART_printZ

		; MOTOR
		in 		ra, PORTD
		cbr		ra, (1 << MT)
		out		PORTD, ra

end:
		rjmp 	end

; DATA

dot: .db ".", 0xd, 0xa, 0x0

start: .db "Begin Test", 0x0


