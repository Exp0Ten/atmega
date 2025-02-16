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
`UART_input` takes the address, pointing to the buffer, stored in `X` and load the user input into it. The input is terminated after `Return` (upon receiving the 0x0d byte). It returns the entire length of the string (including the \n\r and 0x00) in the `T` word register. While reading it sends all of the characters back to the sender.
It also processes some characters:
- `Return` becomes CRLF (Carrige Return and Line Feed)
- `Backspace` becomes BS, ' ', BS, and it will remove the last character from the buffer. It also checks for length and so will not remove bytes when the buffer is empty.
- Nonascii characters are replaced by '.', each byte of the char then becomes a dot (meaning č become "..")
- `Escape` sequences are for now skipped and will just print the raw contents.

`push_string` pushes the string onto the stack. It reads the location of the string from X and pushes it to the space pointed by Y word pointer.
`pop_string` pops the string from the stack pointed to by Y pointer and stored at X pointer. It is also necessary to specify length of the string into the T pointer.

When using stack it is important to use simple yet crucial rules. Lets go over them.
- Stack needs to exit with the same address as it entered a function.
- Stack needs to always be available for calling and returning from functions.
- Decrementing the Stack pointer means allocating bytes, incrementing it means dropping data.
With this in mind, I will now show implementations of these rules in the code:
At the entry of the function, we push our Y word pointer (from here on i will refer to it as "base" pointer) onto stack, effectively saving it (this is the stack pointer location from before we called the function). After that we load the base pointer with Stack Pointer.
```asm
function:
	push Yl
	push Yh
	in Yl, SPL
	in Yh, SPH
```

At the end of the function we do the opposite (AND IN THE OPPOSITE ORDER). We load the 
Stack pointer with our base pointer and then we pop from stack to our base pointer.
```asm
	...

	out SPH, Yh
	out SPL, Yl
	pop Yh      ; we pushed Yh last so we have to pop Yh first
	pop Yl
	ret
```

Essentially, we save the Stack pointer into our base pointer and then load it at the end so we end up in the same place, as long as we make sure our base pointer doesn't change. This is also called creating a Stack Frame.

But what if we want to put parameters, return values and local variables inside the function onto the stack? Well if we were push some parameters and then called a function, then the return address gets pushed and we jump to the function:

```asm
	lds ra, VarA
	push ra
	lds ra, VarB
	push ra
	call add   ; add two 1byte numbers
```
Our stack looks like this

| Address | Content | Notes                                                       |
| ------- | ------- | ----------------------------------------------------------- |
| SP + 4  | VarA    | <- If we didnt change the base pointer it should point here |
| SP + 3  | VarB    |                                                             |
| SP + 2  | retAddr |                                                             |
| SP + 1  | retAddr |                                                             |
| SP ->   | -       | unallocated = will get overwriten                           |
Remember Stack Pointer decrements when pushing values and increments when popping values. We cannot directly pop the parameters, because we would get the retAddr and not the variables. You could potentially save the retAddr else where and then push it again and return, but what if from this function you call another function or the data is too long to be just pushed or popped. This would be a problem so we don't do that. Instead we use the base pointer to load the parameters:
```asm
add:
		push Yl
		push Yh
		in Yl, SPL
		in Yh, SPH    ; we push the base pointer to save the previous one

		add Yl, 4     ; we know we have the VarA saved at SP+4 so we increment the base pointer
		adc Yh, 0

		ld ra, Y      ; we load VarA into ra
		ld rb, -Y     ; we pre decrement the base pointer to point at the VarB and load it into rb

		sbiw Yl, 3    ; we move the base pointer then back so it agains equals stack pointer address

		add ra, rb    ; we add the numbers and the return value will be stored in ra
		; now we load the stack pointer with the base pointer and return		
		out SPH, Yh
		out SPL, Yl
		pop Yh      ; we pushed Yh last so we have to pop Yh first
		pop Yl
		ret
```

I know this looks pretty complicated, but when calling many function it gets very useful. Creating the Stack frame is usually not necessary unless you are allocating variables onto the stack in that function. So here, where we are only reading from the stack and not moving it, we can omit creating the stack frame:
```asm
add:
		ld ra, Y+
		ld rb, Y+
		add ra, rb
		sbiw Yl, 2   ; since we incremented the base pointer by 2 (using the Y+) we now have to again decrement it to the same vaule we started with
		ret
```

If you don't wanna keep track of the increments, you can simply push the base pointer onto the stack:
```asm
add:
		push Yl
		push Yh
		ld ra, Y+
		ld rb, Y+
		add ra, rb
		pop Yh      ; we pop the base pointer in opposite order as we pushed it
		pop Yl
		ret
```

Lastly, if you wish to allocate bytes on the stack for the return value for the function, you can do so by decrementing the stack pointer:

```asm
add:
		add ra, rb
		st Y, ra

main:
		push Yl
		push Yh
		in Yl, SPL		
		in Yh, SPH
		; creating a stack frame because we move the stack pointer after this point
		movw Tl, Yl   ; effectively loading the stack pointer to T word (base and stack pointer are currently the same)
		sbiw Tl, 1    ; we subtract 1 from the T word
		out SPL, Tl
		out SPH, Th
		; we now load the decremented stack pointer
		; our base pointer stays at the original value (pointing to the allocated byte)
		ldi ra, 0xfa
		ldi rb, 0x05
		call add      ; we call the function with the parameters 0xfa and 0x05

		ld rc, Y      ; at the base pointer address is still our return value because we didnt move the base pointer
		; we can load it into rc, and return from main

		out SPH, Yh   ; we reload the stack pointer to original vaules (otherwise we would pop the return value as an address when returning)
		out SPL, Yl
		pop Yh        ; we reload the base pointer of the previous function
		pop Yl
		ret

```

And that's it! I know this was long but understanding stack is crucial for parameters and local variables.

## misc.inc