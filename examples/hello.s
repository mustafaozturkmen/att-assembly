.section .data
msg: .asciz "Hello, World!\n"

.section .text
.global _start

_start:
    mov $1, %rax #system out
    mov $1, %rdi
    lea msg(%rip), %rsi
    mov $14, %rdx #message len
    syscall
    jmp done

done:
    mov $60, %rax
    xor %rdi, %rdi #exit code: 0
    syscall
