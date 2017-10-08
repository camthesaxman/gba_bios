# GBA BIOS
This is a disassembly of the Game Boy Advance BIOS ROM.

It builds the following file:
* gba_bios.bin `md5: a860e8c0b6d573d191e4ec7db1b1e4f6`

[devkitARM](http://devkitpro.org/wiki/Getting_Started/devkitARM) is required to assemble the ROM. Because not all of it has been disassembled yet, an original BIOS is required in order to build. Rename this file to baserom.bin. Once that is done, run `make` to build.
