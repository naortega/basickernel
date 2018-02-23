[org 0x7c00]
KERNEL_OFFSET: equ 0x1000      ; kernel memory offset
	mov [BOOT_DRIVE], dl       ; store boot drive for later.
	mov bp, 0x9000             ; setup the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call load_kernel           ; load our kernel from memory
	call switch_to_pm          ; switch to 32-bit protected mode

	jmp $

%include "print.asm"
%include "print32.asm"
%include "disk.asm"
%include "gdt.asm"
%include "switch_prot.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET      ; address to load the kernel to
	mov dh, 1                  ; number of sectors to load
	mov dl, [BOOT_DRIVE]       ; drive to load from
	call disk_load

	mov bx, MSG_KERNEL_LOADED
	call print_string

	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET

	jmp $

;;;
; Data
BOOT_DRIVE: db 0
MSG_REAL_MODE: db "Started in 16-bit Real Mode",0
MSG_PROT_MODE: db "Successfully landed in 32-bit Protected Mode",0
MSG_LOAD_KERNEL: db "Loading kernel into memory...",0
MSG_KERNEL_LOADED: db "Successfully loaded kernel into memory",0

times 510-($-$$) db 0
dw 0xaa55
