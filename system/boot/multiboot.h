#ifndef SYSTEM_BOOT_MULTIBOOT_H
#define SYSTEM_BOOT_MULTIBOOT_H

#include <type.h>

namespace sys {

struct MultibootInformation {
    uint8_t flags;
    
    void *memory_lower;
    void *memory_higher;

    uint32_t boot_device;

    uint32_t command_line;

    
}__attribute__((packed));

};

#endif