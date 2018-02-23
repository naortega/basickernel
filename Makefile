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
	$(ASM) kernel_entry.asm -f elf -o kernel_entry.o
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o
	$(LD) $(LDFLAGS) -o kernel.bin kernel_entry.o kernel.o
	cat boot_sect.bin kernel.bin > $(BIN)/os-image


.PHONY: clean

clean:
	rm -f *.bin *.o
