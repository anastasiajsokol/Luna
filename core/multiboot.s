; multiboot2 header
section .multiboot
    MAGIC: equ 0xe85250d6   ; multiboot2 magic number
    MODE: equ 0             ; mode for x86 protected mode

    %define header_size (multiboot_header_end - multiboot_header_start) ; represents the size of the header
    %define checksum (-(MAGIC + MODE + header_size))                    ; multiboot2 checksum

    align 4

    multiboot_header_start:
        
        ; starting structure
        dd MAGIC
        dd MODE
        dd header_size
        dd checksum

        ; framebuffer tag
        dw 8    ; type
        dw 0    ; flag
        dd 20   ; size
        dd 1280 ; width
        dd 1024 ; height
        dd 15   ; depth
        
        ; required end tag
        dw 0    ; type
        dw 0    ; flag
        dd 8    ; size

    multiboot_header_end:

; 16 byte aligned 16 KiB stack
section .bss
    align 16

    stack_bottom:
        resb 16384
    stack_top:

section .text
    extern kernel_main
    global _start

    _start:
        ; Current Conditions
        ;   x86 32-bit protected mode
        ;   interrupts disabled
        ;   paging is disabled

        ; setup stack
        mov esp, stack_top

        ; enter high-level kernel (stack must still be aligned to 16 bytes)
        call kernel_main

        ; clear interrupts, then wait for the next one - doing essentially nothing
        ; just in case a non-maskable interrupt somehow occures simply return to waiting
        cli
        .halt:
            hlt
            jmp .halt
