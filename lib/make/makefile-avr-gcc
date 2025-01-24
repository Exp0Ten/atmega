all:
	avr-gcc -mmcu=atmega328p serial-print.c -o serial-print.elf
	avr-objcopy -O ihex -j .text -j .data serial-print.elf serial-print.hex
	"avrdude" -c arduino -p ATMEGA328P -P /dev/ttyUSB0 -b 115200 -U flash:w:serial-print.hex:i
