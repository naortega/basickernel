ASM=nasm
AFLAGS=-f bin
BIN=bin
CFLAGS=-ffreestanding -fno-pie -m32
CC=gcc
LD=ld
LDFLAGS=-melf_i386 -Ttext 0x1000 --oformat binary

basicos:
	mkdir -p $(BIN)
	$(ASM) boot_sect.asm $(AFLAGS) -o boot_sect.bin
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o
	$(LD) $(LDFLAGS) -o kernel.bin kernel.o
	cat boot_sect.bin kernel.bin > $(BIN)/os-image


.PHONY: clean

clean:
	rm *.bin *.o
