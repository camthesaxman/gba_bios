#### Tools ####

GBAGFX   := tools/gbagfx/gbagfx
CC1      := tools/agbcc/bin/agbcc
CC1_OLD  := tools/agbcc/bin/old_agbcc
CPP      := $(DEVKITARM)/bin/arm-none-eabi-cpp
AS       := $(DEVKITARM)/bin/arm-none-eabi-as
LD       := $(DEVKITARM)/bin/arm-none-eabi-ld
OBJCOPY  := $(DEVKITARM)/bin/arm-none-eabi-objcopy

CC1FLAGS := -mthumb-interwork -Wimplicit -Wparentheses -O2 -fhex-asm
CPPFLAGS := -Itools/agbcc/include -iquote include -nostdinc -undef
ASFLAGS  := -mcpu=arm7tdmi -mthumb-interwork -Iasminclude


#### Files ####

ROM      := gba_bios.bin
ELF      := $(ROM:.bin=.elf)
MAP      := $(ROM:.bin=.map)
LDSCRIPT := ldscript.txt
SOURCES  := asm/bios.s
OFILES   := $(addsuffix .o, $(basename $(SOURCES)))

#### Main Targets ####

compare: $(ROM)
	md5sum -c checksum.md5

clean:
	$(RM) $(ROM) $(ELF) $(MAP) $(OFILES) src/*.s

#### Recipes ####

# Get rid of the idiotic built-in rules
.SUFFIXES:

# Stop deleting my files
.PRECIOUS: %.4bpp

# Link ELF file
$(ELF): $(OFILES) $(LDSCRIPT)
	$(LD) -T $(LDSCRIPT) -Map $(MAP) $(OFILES) -o $@

# Build GBA ROM
%.bin: %.elf
	$(OBJCOPY) -S -O binary --gap-fill 0x00 --pad-to 0x4000 $< $@
	# Why the fuck is objcopy adding this garbage to the end of my file? plz fix
	truncate -s $(shell echo $$((0x4000))) $(ROM)

# C source code
%.o: %.c
	$(CPP) $(CPPFLAGS) $< | $(CC1) $(CC1FLAGS) -o $*.s
	echo '.ALIGN 2, 0' >> $*.s
	$(AS) $(ASFLAGS) $*.s -o $*.o

# Assembly source code
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# Graphics files
%.4bpp: %.png
	$(GBAGFX) $< $@
%.gbapal: %.pal
	$(GBAGFX) $< $@
%.lz: %
	$(GBAGFX) $< $@

include gfxdep.mk
