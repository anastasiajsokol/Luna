%define ALIGN    (1 << 0)        ; align loaded modules on page boundaries
%define MEMINFO  (1 << 1)        ; provide memory map

FLAGS:      equ ALIGN | MEMINFO  ; this is the Multiboot 'flag' field
MAGIC:      equ 0x1BADB002       ; 'magic number' lets bootloader find the header
CHECKSUM:   equ -(MAGIC + FLAGS) ; checksum of above, to prove we are multiboot

; GRUB multiboot header
section .multiboot
    align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

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

        ; This is a good place to initialize crucial processor state before the
        ; high-level kernel is entered. It's best to minimize the early
        ; environment where crucial features are offline. Note that the
        ; processor is not fully initialized yet: Features such as floating
        ; point instructions and instruction set extensions are not initialized
        ; yet. The GDT should be loaded here. Paging should be enabled here.
        ; C++ features such as global constructors and exceptions will require
        ; runtime support to work as well.

        ; enter high-level kernel (stack must still be aligned to 16 bytes)
        call kernel_main

        ; clear interrupts, then wait for the next one - doing essentially nothing
        ; just in case a non-maskable interrupt somehow occures simply return to waiting
        cli
        .halt:
            hlt
            jmp .halt
