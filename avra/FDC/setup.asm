baud 9600

;PortD
.define DenS 2
.define DrS0 3
.define DrS1 4
.define MOTOR 5
.define Dir 6
.define STEPP 7

;PortB
.define WRGT 0
.define TR00 1
.define WRPT 2
.define Side 3
.define LED 5

;PortC
.define READ 0
.define WRITE 1
.define INDEX 2
.define READY 3

setup:
		call	UART_init

		; Setting up portD

		; D0 and D1 - RX/TX		0, 1
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
		; B5 - LED				13

		ldi		ra, 0b101001
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

		; SIDE SELECT NORMAL, + pullup
		ldi		ra, 0b1111
		out		PORTB, ra

		; WRITE DATA STANDBY + pullup
		ldi		ra, 0b1111
		out		PORTC, ra

		eor		ra, ra
		ret
