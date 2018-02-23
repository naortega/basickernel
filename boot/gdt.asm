; GDT
gdt_start:

gdt_null:
	dd 0x0               ; the mandatory null-descriptor
	dd 0x0

gdt_code:                ; code segment of descriptor
	dw 0xFFFF            ; Limit (bits 0-15)
	dw 0x0               ; Base (bits 0-15)
	db 0x0               ; Base (bits 16-23
	; 1st flags: (present)1, (privilege)00, (descriptor type)1 -> 1001b
	; type flags: (code)1, (conforming)0, (readable)1, (accessed)0 -> 1010b
	; 2nd flags: (granularity)1, (32-bit default)1, (64-bit seg)0, (AVL)0 -> 1100b
	db 10011010b         ; 1st flags and type flags
	db 11001111b         ; 2nd flags and Limit (bits 16-19)
	db 0x0               ; Base (bits 24-31)

gdt_data:
	; type flags: (code)0, (expand down)0, (writable)1, (accessed)0 -> 0010b
	dw 0xFFFF            ; Limit (bits 0-15)
	dw 0x0               ; Base (bits 0-15)
	db 0x0               ; Base (bits 16-23)
	db 10010010b         ; 1st flags and type flags
	db 11001111b         ; 2nd flags and Limit (bits 16-19)
	db 0x0               ; Base (bits 24-31)

gdt_end:                 ; for calculating size of the gdt

gdt_descriptor:
	dw gdt_end - gdt_start - 1  ; size of our GDT, always decrement true size by one
	dd gdt_start         ; start address of our GDT

;;;
; Constants used for GDT segment offsets
GDT_CODE_SEG: equ gdt_code - gdt_start
GDT_DATA_SEG: equ gdt_data - gdt_start
