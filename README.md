# ATmega coding

This repo documents coding AVR (mainly ATmega) processors, some tools I made and my notes.
I am starting from complete scratch, I gained most info from the datasheets and avr-libc and avr-gcc manuals.
The processor I am using is ATmega328P, and I am mainly focusing on writing the code in assembly as that is why I wanted to learn with these processors. I want to truly dive into the low level of these processors to understand them better.

**I am trying to make everything work right away. But there are some things I make enviroment specific. I'll try to mention it in a different README.md, but my ideal working steps are as follows:**
1. Test some piece of code as is - syntax errors and such
2. Compile and check the objdump - numerical check and possible opti mistakes
3. Test linking - fix as linker needs
4. Upload and runtime test - fix runtime errors and algorith mistakes
5. Automate makefile - if done skip
6. Tidy up code and check back and forth if it is still working
7. Make final notes
8. Automate makefile process