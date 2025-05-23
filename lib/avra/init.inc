.nolist
.equ RESaddr = 0

.macro interrupt
 .nolist
 .ifndef @1_defined
	.define @1_defined
	.set a = PC
 .list
	.org @1
		jmp @0
 .nolist
	.org a
 .else
 	.error "Already defined @1"
 .endif
.endm
.list

	.cseg
	.org 0
_vectors:
		interrupt RESET, RESaddr

	.org 0x36
RESET:
		cli
		eor 	r0, r0
		ldi		r16, 0xff
		mov		r1, r16
		eor 	r16, r16
		out		SREG, r0
		ldi		r28, low(RAMEND)
		ldi		r29, high(RAMEND)
		out		SPL, r28
		out		SPH, r29
		jmp 	main
