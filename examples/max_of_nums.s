.section .data
msg: .asciz "Max: "
call_num1: .asciz "Num 1: "
call_num2: .asciz "Num 2: "
error_msg: .asciz "Invalid input\n"
num1: .space 100
num2: .space 100

.section .text
.global _start

len_of_rsi:
    movb (%rsi), %al
    cmp $0, %al
    je done_method
    inc %rcx
    inc %rsi # move to next char
    jmp len_of_rsi

convert_to_int:
    xor %rbx, %rbx
    movb (%rsi), %bl
    cmp $0, %bl
    je done_method
    cmp $'\n', %bl
    je done_method
    cmp $'0', %bl
    jl print_error
    cmp $'9', %bl
    jg print_error
    subb $'0', %bl
    mov %rcx, %rax   # move current number to rax
    imul $10, %rax   # rax = rax * 10
    add %rbx, %rax   # add digit
    mov %rax, %rcx   # store back in rcx
    inc %rsi
    jmp convert_to_int

done_method:
    ret

_start:
    mov $1, %rax #system out
    mov $1, %rdi
    lea call_num1(%rip), %rsi
    mov $7, %rdx #message len
    syscall

    xor %rdi, %rdi
    lea num1(%rip), %rsi
    mov $100, %rdx
    xor %rax, %rax
    syscall

    mov $1, %rax #system out
    mov $1, %rdi
    lea call_num2(%rip), %rsi
    mov $7, %rdx #message len
    syscall

    xor %rdi, %rdi
    lea num2(%rip), %rsi
    mov $100, %rdx
    xor %rax, %rax
    syscall
    # Convert num_1 to int
    mov $0, %rcx
    lea num1(%rip), %rsi 
    call convert_to_int
    mov %rcx, %r9
    
    # Convert num_1 to int
    mov $0, %rcx
    lea num2(%rip), %rsi 
    call convert_to_int
    mov %rcx, %r10

    cmp %r9, %r10
    jg print_num2

    mov $1, %rax #system out
    mov $1, %rdi
    lea msg(%rip), %rsi
    mov $5, %rdx #message len
    syscall

    lea num1(%rip), %rsi
    mov $0, %rcx
    call len_of_rsi

    mov $1, %rax #system out
    mov $1, %rdi
    lea num1(%rip), %rsi
    mov %rcx, %rdx #message len
    syscall
    jmp done

print_num2:
    mov $1, %rax #system out
    mov $1, %rdi
    lea msg(%rip), %rsi
    mov $5, %rdx #message len
    syscall

    lea num2(%rip), %rsi
    mov $0, %rcx
    call len_of_rsi

    mov $1, %rax #system out
    mov $1, %rdi
    lea num2(%rip), %rsi
    mov %rcx, %rdx #message len
    syscall
    jmp done

print_error:
    mov $1, %rax #system out
    mov $1, %rdi
    lea error_msg(%rip), %rsi
    mov $14, %rdx #message len
    syscall

done:
    mov $60, %rax
    mov $0, %rdi
    syscall
