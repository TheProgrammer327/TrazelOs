# Current directory:
CURRENT_DIR := $(shell pwd)


# Compilation and assembly methods:
export ASM    := nasm
export CC     := x86_64-elf-gcc
export LINKER := x86_64-elf-ld

# asmbller flags: 
export ASSEMBLER_MBR_FLAGS := -f bin -o
export ASSEMBLER_BOOT_LOADER_FLAGS := -f elf64 -o
export ASSEMBLER_OS_FLAGS := -f elf64 -o
# compiler flags:
CURRENT_DIR                   := $(shell pwd)
INCLUDE_DIRS                  := -I$(CURRENT_DIR)/src/os/ -I$(CURRENT_DIR)/src/os/src/
COMPILER_FLAGS                := -Ttext 0x9000 -ffreestanding -mno-red-zone -m64 $(INCLUDE_DIRS)
export COMPILER_RELEASE_FLAGS := $(COMPILER_FLAGS) -O2
export COMPILER_DEBUG_FLAGS   := $(COMPILER_FLAGS) -O0 -DDEBUG=1

# locations:
export BIN_DIR := bin/
export SRC_DIR := src/
export OBJ_DIR := obj/
export ASM_DIR := my_asm/

# files:
export MBR_FILE        := src/mbr/mbr.asm
export MBR_BIN         := $(BIN_DIR)mbr.bin
export MEMORY_PAD_FILE := src/mbr/memoryPad.asm
export MEMORY_PAD_BIN  := $(BIN_DIR)memoryPad.bin
export BOOTLOADER_FILE := src/boot_loader/bootloader.asm
export BOOTLOADER_OBJ  := $(OBJ_DIR)bootloader.o
export OS_BIN          := $(BIN_DIR)os.iso
export KERNEL_BIN      := $(BIN_DIR)kernel.bin

# this removes the ./ prefix at the start:
REMOVE_PREFIX := sed 's|^\./||'
export CPP_FILES     := $(shell find . -name "*.cpp" | $(REMOVE_PREFIX))
export ASM_FILES     := $(shell find src/os/ -name "*.asm" | $(REMOVE_PREFIX))
export OBJ_CPP_FILES := $(addprefix $(OBJ_DIR), $(CPP_FILES:.cpp=.o)   )
export OBJ_ASM_FILES := $(addprefix $(OBJ_DIR), $(ASM_FILES:.asm=Asm.o))
export ASM_CPP_FILES := $(addprefix $(ASM_DIR), $(CPP_FILES:.cpp=.asm) )


# simulator:
export SIMULATOR := qemu-system-x86_64

# simulator flags:
RAM_SIZE   := -m 256M
CPU_TYPE   := -cpu qemu64
CLOCK_TIME := -rtc base=localtime
export SIMULATOR_FLAGS $(RAM_SIZE) $(CPU_TYPE) $(CLOCK_TIME)

#echo colors: 
export ECHO_GREEN_COLOR := \033[0;32m
export ECHO_NO_COLOR    := \033[97m


KERNEL_SIZE ?= $(shell wc -c < $(KERNEL_BIN))
SECTOR_SIZE := 512
export SECTORS_TO_LOAD ?= $(shell if [ -e "$(KERNEL_BIN)" ]; then echo $$((($(KERNEL_SIZE) / $(SECTOR_SIZE)) + 1)); fi)

# this is the memory that is need to be padded so it will be exactly the right amount of memory that should be loaded:
export MEMORY_PAD ?= $(shell if [ -e "$(KERNEL_BIN)" ]; then echo $$(($(SECTOR_SIZE) - ($(KERNEL_SIZE) % $(SECTOR_SIZE)))); fi)


# $(SECTOR_SIZE) - ($(KERNEL_SIZE) % $(SECTOR_SIZE))