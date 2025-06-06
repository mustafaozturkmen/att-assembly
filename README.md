# att-assembly
A beginner-friendly guide to Assembly programming using AT&amp;T syntax (GNU Assembler / GAS).

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


### General Rules
- **Operands Order:** `source → destination`

## `mov` Instruction in AT&T Assembly

The `mov` instruction is used to **copy data** from one location (source) to another (destination). In AT&T syntax, the format is:

```asm
####################################
# mov<size> source, destination    #
#                                  #
# <size>: 'b' | 'w' | 'd' | ''.    #
####################################

mov $5, %rax # moves decimal 5 to rax
movb $5, (%rax) # moves decimal 5 to memory address where rax points

```

