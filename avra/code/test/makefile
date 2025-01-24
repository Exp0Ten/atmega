name = test

asm = $(name).asm
hex = tmp/$(name)/$(name).hex
eep = tmp/$(name)/$(name).eep.hex
list = tmp/$(name)/$(name).list
map = tmp/$(name)/$(name).map


AD_dev = m328p
AD_prog = arduino
AD_baud = 115200
AD_port	= /dev/ttyUSB0

all: $(hex)

$(hex): $(asm)
	@mkdir tmp/$(name) -p
	avra -I /home/azi/atmega/asm/lib -l $(list) -m $(map) -o $(hex) -e $(eep) $(asm)
	@mv $(name).obj tmp/$(name)/$(name).obj

clean:
	rm -rf tmp

upload: $(hex)
	"avrdude" -c $(AD_prog) -b $(AD_baud) -p $(AD_dev) -P $(AD_port) -U flash:w:$(hex):i

dump: $(hex)
	@avr-objdump -m avr -D $(hex)

list: $(hex)
	@cat $(list) | pager
