all:
	avr-gcc -Os -DF_CPU=16000000UL -mmcu=atmega328p serial-print.c -o serial-print.bin
	avr-objcopy -O ihex -R .eeprom serial-print.bin serial-print.hex
	"avrdude" -F -V -c arduino -p ATMEGA328P -P /dev/ttyUSB0 -b 115200 -U flash:w:serial-print.hex
