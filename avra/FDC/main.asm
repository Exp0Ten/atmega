.include "setup.asm"

.include "data.asm"
.include "seek.asm"
.include "write.asm"
.include "read.asm"


main:
		call 	setup

end:
		rjmp 	end
