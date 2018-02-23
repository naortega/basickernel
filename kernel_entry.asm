[bits 32]
[extern main]       ; reference an external label
	call main       ; call the main function of our kernel
	jmp $           ; hang
