.section .data
buffer: .space 100

.section .text
.global _start

len_of_rsi:
    movb (%rsi), %al
    cmp $0, %al
    je done_method
    inc %rcx
    inc %rsi # move to next char
    jmp len_of_rsi

upper:
    movb (%rsi), %al
    inc %rsi
    cmp $0, %al
    je done_method
    cmp $'a', %al
    jl upper
    cmp $'z', %al
    jg upper
    dec %rsi
    subb $'a', %al
    addb $'A', %al
    movb %al, (%rsi)
    inc %rsi
    jmp upper

done_method:
    ret

_start:
    # Read input 
    xor %rdi, %rdi
    lea buffer(%rip), %rsi
    mov $100, %rdx
    xor %rax, %rax
    syscall

    # make all upper cases
    lea buffer(%rip), %rsi 
    call upper

    # Len of input to rcx
    mov $0, %rcx
    lea buffer(%rip), %rsi 
    call len_of_rsi

    # Print upper input
    mov $1, %rax #system out
    mov $1, %rdi
    lea buffer(%rip), %rsi 
    mov %rcx, %rdx #message len
    syscall

    # Exit
    mov $60, %rax
    mov $0, %rdi
    syscall
