.equ RESaddr = 0

.macro interrupt
	.define @1_defined
	.set a = PC
	.org @1
		jmp @0
	.org a
.endm

.macro rest
	.cseg
	.org 0
		interrupt 0x22, RESaddr

	.org 0x22
		eor 	r0, r0
		out		SREG, r0
		ldi		r28, low(RAMEND)
		ldi		r29, high(RAMEND)
		out		SPL, r28
		out		SPH, r29
.endm

.macro rest_i
	.org 0x22
		eor 	r0, r0
		out		SREG, r0
		ldi		r28, low(@0)
		ldi		r29, high(@0)
		out		SPL, r28
		out		SPH, r29
.endm

