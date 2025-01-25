# Some info about my environment
A lot of makefiles and other build scripts depend on this and so i find it important to say the bare minimum about the environment I am using.
### Basic info
 - Intel Amd64 processor
 - Debian Linux

Microprocessor(s) I'm using:
 - ATmega328P @16MHz

### .deb Pkgs for compilation
``` bash
sudo apt install gcc-avr avr-libc avra avr binutils-avr avrdude
```

### Terminal
I am using my personal `build` bash script I have in my path, which automatically switches between the makefiles based on where I am. If you wish to use the makefiles, they are made so they can be completely disconnected from this script and therefore used by copying between folders. You can also use the bash files in the `script` folder, ideally add path to the `build.sh`.

I will add extra things here later on.