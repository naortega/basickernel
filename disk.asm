;;;
; disk_load
; ---------
; Load disk sectors into memory.
;
; Parameters:
;  - dh: number of sectors to read
disk_load:
	pusha
	push dx             ; store `dx' to check if the appropriate number of
                        ; sectors were read later on.
	mov ah, 0x02        ; BIOS read routine
	mov al, dh          ; read `dh' sectors
	mov ch, 0x00        ; select cylinder 0
	mov dh, 0x00        ; select head 0
	mov cl, 0x02        ; start reading from second sector (after the boot
                        ; sector)

	int 0x13            ; BIOS interrupt

	jc disk_load_error  ; if `cf' flag has gone off then a read error has
                        ; occurred

	pop dx              ; restore `dx'
	cmp dh, al          ; were the appropriate amount of sectors read?
	jne disk_load_unexp ; if not then there was an error
	popa
	ret

disk_load_error:
	mov bx, DISK_READ_ERROR   ; print the error
	jmp disk_load_print_exit
disk_load_unexp:
	mov bx, DISK_READ_UNEXP
disk_load_print_exit:
	call print_string
	jmp $                     ; lock due to failure

DISK_READ_UNEXP:
	db "Unexpected amount of sectors read!",0

DISK_READ_ERROR:
	db "Disk read error!",0
