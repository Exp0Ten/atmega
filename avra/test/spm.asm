;.device ATmega328P
;.include "vectors.inc"

.include "m328Pdef.inc"

	.cseg

.macro stack
		ldi		r28, high(@0)
		ldi		r29, low(@0)
		out		SPL, r28
		out		SPH, r29
.endm

stack RAMEND
