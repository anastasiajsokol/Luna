all:
	nasm -felf32 core/multiboot.s -o object/multiboot.o
	i686-elf-g++ -c core/kernel.cpp -o object/kernel.o -std=c++17 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti --pedantic-errors -I./system
	i686-elf-gcc -T core/linker.ld -o bin/luna.bin -ffreestanding -O2 -nostdlib object/*.o -lgcc

iso:
	mkdir -p /tmp/lunaiso/boot/grub
	cp bin/luna.bin /tmp/lunaiso/boot/luna.bin
	cp grub.cfg /tmp/lunaiso/boot/grub/grub.cfg
	grub-mkrescue -o luna.iso /tmp/lunaiso
	rm -r /tmp/lunaiso

qemu:
	qemu-system-i386 -cdrom luna.iso

multiboot:
	grub-file --is-x86-multiboot2 bin/luna.bin

clean:
	rm object/*.o bin/luna.bin luna.iso
