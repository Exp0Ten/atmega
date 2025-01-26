#include <avr/io.h>
#include <defs.h>
;#define io(sfr) (_SFR_IO_ADDR(sfr))

RESET:
		ldi		r16, 0xff
		out		io(DDRB), r16
