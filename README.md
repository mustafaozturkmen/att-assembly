# att-assembly
A beginner-friendly guide to Assembly programming using AT&amp;T syntax (GNU Assembler / GAS).

## Before You Start

If you're new to AT&T assembly syntax, it’s helpful to first look at a simple **Hello World** program written in AT&T syntax.  
This will give you a quick feel for the instruction style, registers, and basic system calls before diving into the details.

Here’s a minimal "Hello World" example in AT&T syntax (Linux x86_64):

```asm
.section .data
msg: .asciz "Hello, World!\n"

.section .text
.globl _start
_start:
    mov $1, %rax            # sys_write system call
    mov $1, %rdi            # file descriptor 1 = stdout
    lea msg(%rip), %rsi     # address of message
    mov $14, %rdx           # message length
    syscall                 # call kernel

    mov $60, %rax           # sys_exit system call
    xor %rdi, %rdi          # status 0
    syscall                 # call kernel to exit

```

## Registers in AT&T Assembly

Registers are small storage locations within the CPU used to perform operations quickly. In AT&T syntax, all registers are prefixed with `%`.

### 🔹 General-Purpose Registers (x86 / x86-64)

| 64-bit | 32-bit | 16-bit | 8-bit (high/low) | Purpose                    |
|--------|--------|--------|------------------|----------------------------|
| `%rax` | `%eax` | `%ax`  | `%ah` / `%al`    | Accumulator                |
| `%rbx` | `%ebx` | `%bx`  | `%bh` / `%bl`    | Base register              |
| `%rcx` | `%ecx` | `%cx`  | `%ch` / `%cl`    | Counter (loops/shifts)     |
| `%rdx` | `%edx` | `%dx`  | `%dh` / `%dl`    | Data register              |
| `%rsi` | `%esi` | `%si`  | — / `%sil`       | Source Index (strings)     |
| `%rdi` | `%edi` | `%di`  | — / `%dil`       | Destination Index (strings)|
| `%rbp` | `%ebp` | `%bp`  | — / `%bpl`       | Base                       |


### 🔹 Extended Registers (x86-64 only)

| Register       | Description               |
|----------------|---------------------------|
| `%r8`–`%r15`   | Additional general-purpose|

Each of these has variants:
- `%r8d`, `%r9d`, ..., `%r15d` (32-bit)
- `%r8w`, ..., `%r15w` (16-bit)
- `%r8b`, ..., `%r15b` (8-bit)


### General Instructions
- **Operands Order:** `source → destination`

## `inc` and `dec` Instructions in AT&T Assembly

The `inc` and `dec` instructions increment or decrement a value by **1**.  
They are equivalent to `add $1, dest` and `sub $1, dest`, but more compact.

```asm
# INC Examples (Increment by 1)
inc %eax                # EAX = EAX + 1 (32-bit)
inc %rbx                # RBX = RBX + 1 (64-bit)
inc %cl                 # CL = CL + 1 (8-bit)
inc %si                 # SI = SI + 1 (16-bit)
inc (%eax)              # Increase value at address in EAX by 1
inc 4(%rbp)             # Increase value at [RBP + 4] by 1

# DEC Examples (Decrement by 1)
dec %ecx                # ECX = ECX - 1 (32-bit)
dec %rdi                # RDI = RDI - 1 (64-bit)
dec %al                 # AL = AL - 1 (8-bit)
dec %dx                 # DX = DX - 1 (16-bit)
dec (%ebx)              # Decrease value at address in EBX by 1
dec 12(%rbp)            # Decrease value at [RBP + 12] by 1
```

## 🧮 `lea` (Load Effective Address) Instruction in AT&T Assembly

The `lea` instruction **loads the address** calculated by the addressing mode into a register.  
It does **not** load the value at the address, but the computed address itself.

```asm
# Syntax:
#leaq source, destination   # destination ← effective address of source

# Examples:

lea text(%rip), %rax           # Load address text data into RAX
lea message(%rip), %rax        # Load address message data into RAX
lea (%rbx,%rcx,4), %rdx        # Load address (RBX + RCX*4) into RDX
lea 4(%rsp,%rax,2), %rdi       # Load address (RSP + RAX*2 + 4) into RDI
lea -16(%rbp), %rsi            # Load address (RBP - 16) into RSI
lea (%rax), %rcx               # Load address in RAX into RCX (copy pointer)
```

## `mov` Instruction in AT&T Assembly

The `mov` instruction is used to **copy data** from one location (source) to another (destination). In AT&T syntax, the format is:

```asm
####################################
# mov<size> source, destination    #
#                                  #
# <size>: 'b'|'w'|'d'|'q'|''       #
####################################

movb $1, %al         # Move 1 into AL (8-bit)
movw $2, %bx         # Move 2 into BX (16-bit)
movl $3, %ecx        # Move 3 into ECX (32-bit)
movq $4, %rdx        # Move 4 into RDX (64-bit)
mov $4, %rdx        # Move 4 into RDX (64-bit)

movl %eax, %ebx        # Copy contents of EAX to EBX
movl (%eax), %ebx      # Move value from address in EAX into EBX
movl %eax, (%ebx)      # Store EAX value into memory at address in EBX
movl 8(%rbp), %eax     # Load value from stack offset +8 into EAX

```

## `add` and `sub` Instructions in AT&T Assembly

These instructions perform arithmetic by modifying the destination operand.  
They follow the form: `operation source, destination` (remember: AT&T is **source → destination**).

```asm
# ADD Examples
addl $5, %eax              # EAX = EAX + 5 (add immediate to register)
addl %ebx, %eax            # EAX = EAX + EBX (add register to register)
add (%rbx), %rax          # RAX = RAX + value at memory address in RBX
addl 8(%rbp), %ecx         # ECX = ECX + [RBP + 8] (add from stack)
addl %eax, (%rbx)          # [RBX] = [RBX] + EAX (add register to memory)
addl $10, 12(%rsp)         # [RSP + 12] = [RSP + 12] + 10 (immediate to memory)
addl 4(%ebx,%ecx,4), %eax  # EAX = EAX + [EBX + ECX*4 + 4] (complex addressing)

# SUB Examples
subl $3, %ecx              # ECX = ECX - 3 (subtract immediate from register)
subl %edx, %eax            # EAX = EAX - EDX (subtract register from register)
sub %rax, (%rsp)          # [RSP] = [RSP] - RAX (register from memory)
subl 16(%rbp), %edx        # EDX = EDX - [RBP + 16] (memory from register)
subl $1, (%rbx)            # [RBX] = [RBX] - 1 (decrement memory value)
subl (%rsi), %edi          # EDI = EDI - value at [RSI]
sub $8, %rsp              # Stack pointer adjustment: allocate 8 bytes
add $8, %rsp              # Stack pointer restore: deallocate 8 bytes

```
