ASM=nasm
BIN=bin
CC=i686-elf-gcc
CFLAGS=-ffreestanding -fno-pie -ansi
LD=i686-elf-ld
LDFLAGS=-Ttext 0x1000 --oformat binary

OBJ=kernel/kernel_entry.o kernel/kernel.o kernel/ports.o kernel/util.o drivers/screen.o

all: os-image

os-image: boot/boot_sect.bin kernel/kernel.bin
	mkdir -p $(BIN)
	cat $^ > $(BIN)/$@

# build kernel binary file
kernel/kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	$(ASM) $< -f elf -o $@

%.bin: %.asm
	$(ASM) $< -f bin -I 'boot/' -o $@

.PHONY: clean

clean:
	rm -rf boot/*.bin kernel/*.bin
	rm -rf kernel/*.o boot/*.o drivers/*.o
