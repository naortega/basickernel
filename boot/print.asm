;;;
; print_string
; ------------
; Print a string from memory.
;
; Parameters:
;  - bx: pointer to string
;
; Internal Variables:
;  - ah: scrolling teletype BIOS routine code
;  - al: Byte containing character to print
;  - bx: shifting pointer to string
print_string:
	pusha                    ; save the state of all registers to the stack

	mov ah, 0x0e             ; scrolling teletype BIOS routine code
print_string_start:
	mov al, [bx]             ; load first letter into `al'
	cmp al, 0
	je print_string_end      ; if null-termination then return
	int 0x10                 ; print the letter
	add bx, 0x1              ; offset to next character
	jmp print_string_start   ; go back to beginning

print_string_end:
	mov al, 0xA
	int 0x10
	mov al, 0xD
	int 0x10
	popa                     ; return the state of all the registers
	ret
