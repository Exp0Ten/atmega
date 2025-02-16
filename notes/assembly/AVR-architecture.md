# AVR architecture specification
AVR stands for Advanced Virtual RISC (Restricted Instruction Set Computer).
This architecture gives allows for universal,low power, low cost and easy usage. I'll be covering mostly the Atmega architecture but the Instruction Set (IS) stays mostly the same. You would normally use C or Arduino coding language to program AVR computers, but I wanted to focus on assembly to gain experience in working with microprocessors and also because I find coding in AMD64 assembly quite boring as there are strong limitations on direct hardware communication.
Essentially, what I'm doing is way too complex and unnecessarily hard, but offers a lot of experience and fun (if you're like me).

I'll start with describing the architecture, then move on assembly instruction summary. You can find both of these in the .pdf files `atmega328p.pdf` and `AVR-IS.pdf` in the `doc/` folder.

## Atmega and AVR arch
The Micro-controller Unit (MCUs) has 32 General Purpose Registers (GPRs) r0 to r31.
They operate in 8-bit and 16-bit architecture. They use the Harvard Architecture, meaning they have memory split for code and for data. The memory is split between 3 types:
- FLASH - 32KB - here is the program code stored (+ constants)
- SRAM - 2KB - here is data store and memory mapped IO
- EEPROM - 1KB - Data (doesnt get lost on powerloss)
The instructions are either 16-bit long or 32-bit long, Program counter counts in words (2 bytes).
The MCUs can run at low tens of MHz speed. Most instructions take 1 clock cycle to complete.

Onboard there are many interfaces, i will just mention them quickly here:
 - Counters
 - External Interrupts
 - USART interface
 - Sleep modes for power-saving
 - Analog Input pins
It communicates via the Memory Mapped Input/Output (IO), which means that to the user saves numbers into locations on SRAM and those control the state of the MCU. These are called I/O Registers and they are in the first 256 bytes in the SRAM (first 32 bytes are GPRs) (next 32 bytes are most commonly used and can be used with the optimized `in` and `out` instructions).

## Instruction set
The instruction set has many groups. To summarise them i will just talk over the most significant ones. All of them can be found in the docs.
Arithmetic:
- ADD, SUB - with carry, immediate value and operations on words
- AND, OR, EOR and shift instructions - bitwise instructions
- INC, DEC - increment, decrement
- SER, CLR, MUL - Set reg, clear reg, multiply

Branching: (jumps, conditionals and more)
 - JMP, RJMP, CALL, RCALL, RET - jumping to address, calling a function (setting return), returning
 - CP, CPI, CPC - Compare registers, or with immediate vaule (IMM), or with carry bit
 - SBRC, SBRS - skip next instruction if bit set or cleared
 - Branching if equal, not equal, less than, greater or equal than ...

Memory Instruction:
 - LDS, STS - direct memory access
 - LD, ST - indirect using registers
 - IN, OUT - only for the first 32 bytes
 - PUSH, POP - Stack

And rest is NOP, SLEEP, BREAK.

I recommend looking into the IS summary, contains examples.