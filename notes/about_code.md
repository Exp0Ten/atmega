# Assembly
In the notes directory is a folder `notes/assembly/`. These notes explain basic information about coding in assembly. It presumes you already know what assembly is (that it's direct representation of instructions the MCU performs, using registers for working, branch instructions for conditional execution and repetition, and reading and writing to memory, computing whatever you wish to compute).

Instead in here, I will try to cover some of my assembly practices and how to read the assembly code. I'd like to say these are good practises, but I am not the best person to judge.

## Tabbing
I use indentation in the following way as i find it to be the most readable:
 - Labels - without a tab. If it is a sublabel (like loop) i like to place it on 1 space indent
 - Directive - without a tab for .include, .equ, and similar. I use 4 space tab for .global and .org and those with similar functions.
 - Instructions - 8 space (2 tab) indent. after opcode I tab 1 to 2 times so there the arguments stay on the same line as the opcodes with 4 characters. After the first argument I use ', ' with no tabbing.
 - Comments - i try to place them at the same line and use '; comment' format
Example:
```
.nolist
.include "atmega328p.inc"
.list
	.global RESET
RESET:
		jmp 	main

main:
		ldi 	r19, 0xff
		out 	DDRB, r19
 loop:
 		out		PORTB, r19
 		call	delay
 		out		PORTB, r0
		call	delay

		rjmp 	loop
```

Using the double tab for opcode can get a little frustrating tho.

## Naming
Naming is a very important part in any programming language. I try to use full words. I use acronyms only for the full word labels I define, so `delay:` will have sublabel `dloop:` or `d_loop:`. I tend to not use numbers, unless in locations close together.
I also like to use 0x0a over 10 unless I am working with precalculated constants.
I also recommend using `>> << ~ & |` and more operators when making constants as they make it a lot nicer to read.

## Registers
Refer to `lib.md` to the chapter about `regs.inc`.

## Use labels and definitions
They help a lot. Try to write the code in a way where you can use it as a function in a different one. But this is optimisation and its better to do this after you have had the first successful runtime. Macros allow stronger math with less space taken up.

## Ideally optimise for size
This usually means optimising for speed as well. You can use `-Os` flag with the avr-gcc, i recommend testing it for yourself though.

READ THE MANUALS. In `notes/doc` you have all of the .pdf files and datasheets, i recommend them for finding specific stuff and understanding how something works
