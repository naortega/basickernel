[bits 16]
switch_to_pm:
	cli                         ; turn off all interrupts until we have properly
                                ; properly set them up

	lgdt [gdt_descriptor]       ; load the global descriptor table defining
							    ; protected mode segments

	mov eax, cr0                ; set flag in register to switch to protected mode
	or eax, 0x1
	mov cr0, eax

	jmp GDT_CODE_SEG:init_pm    ; make a far jump to the 32-bit code forcing a flush
                                ; of the pipelining

[bits 32]
; initialize registers and the stack once in protected mode
init_pm:
	mov ax, GDT_DATA_SEG        ; point our new segment registers to the data
	mov ds, ax                  ; selector defined in the GDT, since we cannot
	mov ss, ax                  ; use the old 16-bit code
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000            ; Update the stack position so it's at the top
	mov esp, ebp                ; of the free space

	call BEGIN_PM
