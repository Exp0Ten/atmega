.include "m328Pdef.inc"

	; This file documents the macros in avra assembler
	.cseg

				; simple macro that prints "Hi." during the compilation process
.macro hello			; we begin a macro by the .macro directive, followed by the name
	.message "Hi."		; inside the body of a macro we can put any code: directive, labels, instructions. Anything you would write yourself in the code
.endm					; we end the macro definition and body by using the .endm (.endmacro) directive

hello			; we can the use the macro by simply writing its name somewhere in the code

.macro clear_registers	; this macros clears the first four registers
		eor 	r0, r0	; sets r0 to 0x00 (XORs r0 with itself)
		eor 	r1, r1
		eor 	r2, r2
		eor 	r3, r3
.endm

clear_registers	; again by calling its name we run the macro
						; some code here
clear_registers 		; we can run the macro as many times we want (be careful on redifinitions tho)

	; it would be nice tho if we could use it for other registers as well - specify parameters

.macro clear 			; we make a new macro clear
		eor 	@0, @0 	; here we can specify the register we want to clear, @0 will be replace with the first parameter, which will be our register
.endm
				; you can have up to 10 parameters in a macro
clear r0
clear r1
; clear 		; on its own it will raise a compilation error, not enough parameters specified
; clear r0 r1 	; this will error as well, too many parameters specified

.if r0 == r0
.message "true"
.endif

;.macro stack
;		ldi		r28, 0xff
;		ldi		r29, 0x08
;		out		SPL, r28
;		out		SPH, r29
;.endm
;
;.macro stack_i
;		ldi		r28, high(@0)
;		ldi		r29, low(@0)
;		out		SPL, r28
;		out		SPH, r29
;.endm
;
;
;
;
;stack [0x2ff]
;stack
;
