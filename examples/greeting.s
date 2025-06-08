.section .data
msg: .asciz "Hello, "
buffer: .space 100

.section .text
.global _start

len_of_rsi:
    movb (%rsi), %al
    cmp $0, %al
    je done_len_of_rsi
    inc %rcx
    inc %rsi # move to next char
    jmp len_of_rsi

done_len_of_rsi:
    ret

_start:
    # Read input 
    xor %rdi, %rdi
    lea buffer(%rip), %rsi
    mov $100, %rdx
    xor %rax, %rax
    syscall

    # Print "Hello, "
    mov $1, %rax #system out
    mov $1, %rdi
    lea msg(%rip), %rsi 
    mov $7, %rdx #message len
    syscall

    # Len of input to rcx
    mov $0, %rcx
    lea buffer(%rip), %rsi 
    call len_of_rsi

    # Print entered input
    mov $1, %rax #system out
    mov $1, %rdi
    lea buffer(%rip), %rsi 
    mov %rcx, %rdx #message len
    syscall

    # Exit
    mov $60, %rax
    mov $0, %rdi
    syscall
