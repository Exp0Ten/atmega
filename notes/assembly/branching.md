# Flags
In the Status Register (SREG), there are store the flags that the MCU operates with.

| I                             | T                    | H                         | S                                                             | V                                                   | N                             | Z                                     | C                                      |
| ----------------------------- | -------------------- | ------------------------- | ------------------------------------------------------------- | --------------------------------------------------- | ----------------------------- | ------------------------------------- | -------------------------------------- |
| Global Interrupt Enable       | Transfer Flag        | HalfCarry Flag            | Sign Flag                                                     | 2Complent Overflow Flag                             | Negative Flag                 | Zero Flag                             | Carry Flag                             |
| Set if interrupts are enabled | User controlled Flag | Set if 4 LS-bits overflow | Set if 2C overflow occured and the number was a signed number | Set if number overflows from the 2Complements range | Set if the number is negative | Set if the Rd is zero after operation | Set if operation overflowed with carry |

The best definition for these is in chapter `6.45 CP – Compare` in AVR-IS.

# Branching
Branching is not so simple as I thought at the start, so here is everything you need to know.
Relative jumps and calls can reach from +2K to -2K of addresses in Flash. Meaning you can use them pretty much everywhere you'd like to, unless you are writing from one end of Flash to the other (it should also support wrapping over the last address in Flash). Otherwise you can use jmp and call. You can also ijmp and icall for indirect jump via the Z word pointer register.

You can skip an instruction by testing a bit in a register or Memory mapped IO PORT (not any address, just 0x40 to 0x7f). That also includes the SREG. You can find these instructions in the documents.

Conditional branching uses most arithmetic instructions and the Compare instructions. All branch instructions can jump from +63 to -64 bytes in the code.
Here is the list of when to use which branching instruction:
BRGE - greater than or equal, BRLT - less than
- these two are for working with twos complement signed numbers, S flag
BRSH - same or higher than, BRLO - lower than
 - these are for unsigned numbers, C flag
BRNE - not equal, BREQ - equal
 - looks at the Z flag
BRBC - cleared bit in SREG, BRBS - set bit in SREG
- user branching
The rest are derivatives of the BRBC and BRBS instructions.
You can find this in the Chapter 4 of `AVR-IS.pdf`.