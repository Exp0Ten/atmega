# Stack
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