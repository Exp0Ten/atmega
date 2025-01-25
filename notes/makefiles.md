# Makefiles
In the folder `lib/make` you can notice a large amount of makefiles. These were the ones i was using before starting this repo, having to copy and paste them. Now i have rewritten them so they can be used with the build scripts.

Now I will talk a bit about what they do and mention the compilation process for each tool-chain.
## avra
This tool uses the `makefile-avra` file in `lib/make`.
The whole file is only name dependent, so you just need to specify the name of the file (without suffix).
It makes the tmp folder, and stores there all of the compilation files. We want to make the .hex file. With this tool we only need to use the avra command.
We specify the `-I` flag for the library folder. The `-l -m -e` make the according list, map and eeprom.hex files. `-o` makes the .hex file.
Inside the assembly file we need to include the file of the microprocessor. The normal syntax is `.include "m328pdef.inc"` but i have copied the file and renamed it in my lib folder as `.include "atmega328p.inc"`. Don't forget to use your own name of the MCU.
Running `build.sh clean` will act the same way as `make clean`. This applies for every other section in the makefile, but only for the first one (the build script passes only the first argument to the makefile).
`clean` will remove the `tmp` subdir. `dump` dumps the disassembly. `list` opens the list file. and `upload` runs the upload makefile.
And that's all. Easy right? It will get Much Worse.

## asm (avr-gcc)
The makefile `makefile-asm` uses the avr-gcc and runs the tool-chain also in one command. But its a large one and so it needs a lot of explanation.
The first flag `-nostartfiles` will prevent it from linking the files from the avr-libc, namely the vectors, the end and the debug code it makes. Avr-gcc does this so you don't have to worry about it yourself, but i found that to take away the control over the assembly file and size. Removing this flag will include these again, but you will have to use the 'main' label in your code (mostly as the main function). 
The assembler flags are `-I` which specifies the lib folder and `-alsm=FILE` which specifies the creation of the list file. By running `avr-as --help` you can find all of the possible flags.
Since we are not running the avr-as on its own but by using avr-gcc we need to specify `-Xassembler` flag before EVERY word (so `-Xassembler -I -Xassembler /path/to/libdir` and this will specify only 1 flag).
Linker flags behave the same. We use `-e` as entry point and the address `0` to start at the beginning of the memory (I will talk about this in Atmega memory specs, but here is the first interrupt jump to the reset interrupt subroutine). We also use the `-S` to strip all of the debug symbols. Again dont forget to use the `-Xlinker` before EVERY word.
Lastly we specify the `-mmcu=` flag to specify wich AVR microprocessor we are using (namely `-mmcu=atmega328p`). And most importantly we need to specify `-x assembler-with-cpp` flag to enable preprocessing the assembly file. You can also rename the filename suffix to .S or .sx to enable it, but i like the .asm suffix. You don't need this if you do not wish to use the avr-libc libraries but i also removes most directives and definitions.
After compilation we need to use `avr-objcopy` to extract the .text and .data sections into ihex format (.hex file).
And that is all. I recommend checking the flags, but finding info on these was very hard.

## Upload (lib/make/upload)
We are using the `avrdude` utility to program the chip. I'm using an arduino board so uploading is easy and is done through the USB. Change the programmer and port if you are using a different one. Also baud rate is chosen somewhat randomly, depends on fast you can/want to upload the code. And don't forget to change the AD_dev variable to select which avr chip you are using.

## avr-gcc c code
Not done yet but should not be hard to make.
