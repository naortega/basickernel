ASM=nasm
AFLAGS=-f bin
BIN=bin
CFLAGS=-ffreestanding -fno-pie -m32
CC=gcc
LD=ld
LDFLAGS=-melf_i386 -Ttext 0x1000 --oformat binary

all: os-image

os-image: boot_sect.bin kernel.bin
	mkdir -p $(BIN)
	cat $^ > $(BIN)/$@

# build kernel binary file
kernel.bin: kernel_entry.o kernel.o
	$(LD) $(LDFLAGS) $^ -o $@

# build kernel object file
kernel.o: kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

# build kernel entry object file
kernel_entry.o: kernel_entry.asm
	$(ASM) -f elf $< -o $@

boot_sect.bin: boot_sect.asm
	$(ASM) $< $(AFLAGS) -o $@

basicos: boot_sect.bin kernel.bin
	mkdir -p $(BIN)
	cat boot_sect.bin kernel.bin > $(BIN)/os-image


.PHONY: clean

clean:
	rm -f *.bin *.o
