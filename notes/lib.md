# Lib
In the `lib/` folder you can find all of the files used for building and writing the code more neatly and organised. I have explained the makefiles already so i will mainly go over the `.inc` files in the subfolder `avra`.

## atmega328p.inc
This file is a direct copy from the avra libraries. The original file was called `m328pdefs.inc`. I moved it into the local lib so I can look into the definitions and edit them if there would arise the need to, though I tried to not edit it to keep it identical to the official library one.

## init.inc
This file sets up automatically the `_vectors` label and then the `RESET` interrupt subroutine. It automatically initialises Stack Pointer to `RAMEND` label (0x8FF in our case) and clears the `StatusREG`, sets up registers (`r0 -> 0x00`) and disable global interrupt. Then the code jumps to the main function (doesn't call it!).
This file also contains a macro which automatically puts the `jmp InterruptADDR` instructions into the `_vector` table. Usage is `interrupt SubroutineLABEL, InterruptNAMEaddr`, eg. `intterupt RESET, RESaddr` will write a `jmp RESET` at address 0x00 in flash (program) memory.

## regs.inc
Register alias definition:
- `r0` 	-> zero	 - (contains 0x00 at most times or with short temporary vaules)
- `r1` 	-> full	 - (contains 0xff at most times or with short temporary vaules)
- `r2-r9` 		 - math
- `r10-r13`		 - compare math
- `r14` -> sava	 - tmp
- `r15` -> savb	 - tmp
- `r16` -> ra	 - GPR, param, return
- `r17` -> rb	 - GPR, param, return
- `r18` -> rc	 - GPR, param, return
- `r19` -> rd	 - GPR, param, return
- `r20` -> ri 	 - GPR, counter
- `r21` -> rj 	 - GPR, counter
- `rj:ri` -> I 	 - word counter (not defined)
- `r22` -> rs 	 - GPR, status and cmp
- `r23` -> rio 	 - GPR, io
- `r24` -> Tl
- `r25` -> Th
- `Th:Tl` -> T 	 - custom T word register for lenth and word operations (not defined)
- `r26` -> Xl
- `r27` -> Xh
- `Xh:Xl` -> X 	 - data pointer
- `r28` -> Yl
- `r29` -> Yh
- `Yh:Yl` -> Y 	 - stack base pointer
- `r30` -> Zl
- `r31` -> Zh
- `Zh:Zl` -> Z 	 - program memory pointer (for loading from flash and indirect jumping)

## uart.inc
Contains functions to setup and use the USART interface in asynchronous mode. `UART_init` sets up the interface (RX and TX enable, 8N1 config). You need to run the `baud BAUDrate` macro for this to work (eg. `baud 9600`).
`UART_send` sends the byte in `r16` to the other computer, also modifies `r17`.
`UART_recieve` receives one byte from the other computer and returns it in `r16`, also modifies `r17`.
`UART_print` prints the 0x00 terminated (C-like) string, sending each byte to the other computer. The pointer to the string is stored in `X`.

## text.inc
Contains functions for manipulating with strings and setting up the text interface.
`UART_input` takes the address, pointing to the buffer, stored in `X` and load the user input into it. The input is terminated after `Return` (upon receiving the 0x0d byte). It returns the entire length of the string (including the \n\r) in the `T` word register. While reading it sends all of the characters back to the sender.
It also processes some characters:
- `Return` becomes CRLF (Carrige Return and Line Feed)
- `Backspace` becomes BS, ' ', BS, and it will remove the last character from the buffer. It also checks for length and so will not remove bytes when the buffer is empty.
- Nonascii characters are replaced by '.', each byte of the char then becomes a dot (meaning č become "..")
- `Escape` sequences are for now skipped and will just print the raw contents.

`push_string` pushes the string onto the stack. It reads the location of the string from X and pushes it to the space pointed by Y word pointer.
`pop_string` pops the string from the stack pointed to by Y pointer and stored at X pointer. It is also necessary to specify length of the string into the T pointer.

See `assembly/stack.md` for info how to handle stack.

Contains more string functions as well, see `functions.md` for complete list and usage.
## misc.inc
This file contains macros which slightly help or change the looks of something. Nothing important code-vise (tho some pretty cool stuff with the assembler).