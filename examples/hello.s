.section .data
msg: .asciz "Hello, World!\n"

.section .text
.global _start

_start:
    mov $1, %rax # syscall: write
    mov $1, %rdi # arg1: stdout
    lea msg(%rip), %rsi # arg2: message address
    mov $14, %rdx #arg3: message len
    syscall
    jmp done

done:
    mov $60, %rax
    xor %rdi, %rdi #exit code: 0 same as mov $0, %rdi
    syscall
