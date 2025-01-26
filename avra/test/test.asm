.include "m328Pdef.inc"
.include "init.inc"

	.dseg
counter: .byte 4

	.cseg
		interrupt RESET, RESaddr
RESET:
		rest 	[0x20]
;		rest
		cli
		jmp 	main

main:
		ldi		r26, low(counter)
		ldi		r27, high(counter)		

		ld 		r4, Z+
		ld 		r5, Z+
		ld 		r6, Z+
		ld 		r7, Z+

;		lds		r4, counter
;		lds		r5, counter+1
;		lds		r6, counter+2
;		lds		r7, counter+3

		jmp 	end

end:
		rjmp 	end
