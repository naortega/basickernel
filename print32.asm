[bits 32]
VIDEO_MEMORY: equ 0xB8000
WHITE_ON_BLACK: equ 0x0F

;;;
; print_string_pm
; ------------
; Print a string stored in memory.
;
; Parameters:
;  - ebx: pointer to string in memory
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY             ; set `edx' to the start of the video memory

print_string_pm_loop:
	mov al, [ebx]                     ; store the char at `ebx' in `al'
	mov ah, WHITE_ON_BLACK            ; store the attributes in `ah'
	cmp al, 0                         ; if null-termination then done
	je print_string_pm_done

	mov [edx], ax                     ; store char and attributes
	add ebx, 1                        ; increment ebx to next char
	add edx, 2                        ; increment to next char cell in vidmem

	jmp print_string_pm_loop

print_string_pm_done:
	popa
	ret
