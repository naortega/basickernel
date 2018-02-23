ASM=nasm
BIN=bin
CFLAGS=-ffreestanding -fno-pie -m32
CC=gcc
LD=ld
LDFLAGS=-melf_i386 -Ttext 0x1000 --oformat binary

OBJ=kernel/kernel_entry.o kernel/kernel.o

all: os-image

os-image: boot/boot_sect.bin kernel/kernel.bin
	mkdir -p $(BIN)
	cat $^ > $(BIN)/$@

# build kernel binary file
kernel/kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

%.o: %.c ${HEADERS}
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	$(ASM) $< -f elf -o $@

%.bin: %.asm
	$(ASM) $< -f bin -I 'boot/' -o $@

.PHONY: clean

clean:
	rm -rf boot/*.bin boot/*.o
	rm -rf kernel/*.o boot/*.o drivers/*.o
