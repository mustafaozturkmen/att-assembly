.section .data
msg: .asciz "Hello, "
buffer: .space 100

.section .text
.global _start

len_of_rsi:
    movb (%rsi), %al #al = pointed char
    cmp $0, %al # if %al is null then end of the string
    je done_len_of_rsi # jump to done
    inc %rcx # increase len
    inc %rsi # move to next char
    jmp len_of_rsi

done_len_of_rsi:
    ret

_start:
    # Read input 
    xor %rdi, %rdi # stdin
    lea buffer(%rip), %rsi # buffer address
    mov $100, %rdx # message length
    xor %rax, %rax # rax = 0, read
    syscall

    # Print "Hello, "
    mov $1, %rax
    mov $1, %rdi
    lea msg(%rip), %rsi 
    mov $7, %rdx #message len
    syscall

    # Len of input to rcx
    mov $0, %rcx
    lea buffer(%rip), %rsi 
    call len_of_rsi

    # Print entered input
    mov $1, %rax
    mov $1, %rdi
    lea buffer(%rip), %rsi 
    mov %rcx, %rdx #message len
    syscall

    # Exit
    mov $60, %rax
    mov $0, %rdi # exit code: 0
    syscall
