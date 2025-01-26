.nolist
.include "atmega328p.inc"
.include "init.inc"
.list

interrupt RESET, RESaddr
RESET:
		rest
		rjmp end

end:
		rjmp end
