# Tree
Here is a short rundown of the working tree directory:

- #### asm
- #### avra
- #### code
- #### lib
- #### notes
- #### script

## asm
This folder contains all assembly code, which is compiled using the avr-gcc tool-chain. Its the preferable one as it has more options and can be used easily with object files from compiled from c code and other languages.
The compilation process is a lot more difficult though. Explanation of that in makefiles.md.
This was my main problem as it took me so long to figure out some things and the actual documentation is very hard to find or access. Although after looking into normal gcc documentation, I found a lot of answers there and so decide to stick to it as well.
## avra
This is the second assembly folder and is compiled with the avra tool. Its similar to the Atmel Studio compiler (AVRASM2), but has some changes. It has less directives, which I found to be important to me, namely the .rept directive was missing, but this one could be easily written using the other directives (something I will look into).
The compilation is easy, works reliably and well. There are still some of things missing in the documentation. I have some personal goals with this project (mainly learning and designing things on the low level), but if there is gonna be my secondary goal, it will be to document the things I found lacking and then share it.
## code
It was a great mistake to do everything in assembly and would be far more beneficial to write everything in c, but personally i enjoy assembly more and am rather unskilled in c code. I will go here and test stuff out, or make some libs for the things I am doing in assembly, but other than that I would have to properly learn c code first.
Me struggling with avr-gcc so much is also due to this fact. I also wanted to try coding some stuff in rust for the atmega microprocessors but i dont think i will really continue in that.

## lib
Initially this should have been a folder only for the .inc files that i have to rewrite in order for them to be usable (instead of c avr/io.h file) but that was when I couldn't find any info on why it wasn't working. Anyway now it is populated with makefiles and my personal library files.

## notes
I create a lot of these through out the project so I made one folder dedicated to it. I'm using Obsidian to write all of this down, as i spend too much time in the terminal when writing assembly (I'd use VSC but there are no useful extensions). I will try put everything here as much as for anyone reading this as for me too, because there are some things I don't think I would find again.
## script
This folder is for build scripts and other scripts. It is part of my integrated build system I might one day publish as well. Essentially all I have to do is `$ build` to build anything anywhere according to correct environment rules. Makes the process so much easier.