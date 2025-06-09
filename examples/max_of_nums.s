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
    movb (%rsi), %al #al = pointed char
    cmp $0, %al # if %al is null then end of the string
    je done_method # jump to done
    inc %rcx # increase len
    inc %rsi # move to next char
    jmp len_of_rsi

convert_to_int:
    xor %rbx, %rbx #clear %bl 
    movb (%rsi), %bl #put current char into bl
    cmp $0, %bl #if end of string jump to done
    je done_method
    cmp $'\n', %bl #new line character can be included at end of string
    je done_method
    cmp $'0', %bl #lower than char '0', not a digit
    jl print_error
    cmp $'9', %bl #higher than char '9', not a digit
    jg print_error
    subb $'0', %bl #int value of char is %bl - char value of zero
    mov %rcx, %rax   # move current number to rax
    imul $10, %rax   # rax = rax * 10
    add %rbx, %rax   # add digit
    mov %rax, %rcx   # store back in rcx
    inc %rsi
    jmp convert_to_int

done_method:
    ret

_start:
    #print 'Num 1: '
    mov $1, %rax #system out
    mov $1, %rdi
    lea call_num1(%rip), %rsi
    mov $7, %rdx #message len
    syscall

    #Read num1
    xor %rdi, %rdi
    lea num1(%rip), %rsi
    mov $100, %rdx
    xor %rax, %rax
    syscall

    #print 'Num 2: '
    mov $1, %rax #system out
    mov $1, %rdi
    lea call_num2(%rip), %rsi
    mov $7, %rdx #message len
    syscall

    #Read num1
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

    #r9 stores num1 and r10 stores num2
    cmp %r9, %r10 
    jg print_num2 #if r10 is greater than print num2
    
    ## else print num1
    #print 'Max: '
    mov $1, %rax #system out
    mov $1, %rdi
    lea msg(%rip), %rsi
    mov $5, %rdx #message len
    syscall

    lea num1(%rip), %rsi
    mov $0, %rcx
    call len_of_rsi

    #print num1
    mov $1, %rax #system out
    mov $1, %rdi
    lea num1(%rip), %rsi
    mov %rcx, %rdx #message len
    syscall
    jmp done

print_num2:
    #print 'Max: '
    mov $1, %rax #system out
    mov $1, %rdi
    lea msg(%rip), %rsi
    mov $5, %rdx #message len
    syscall

    lea num2(%rip), %rsi
    mov $0, %rcx
    call len_of_rsi

    #print num2
    mov $1, %rax #system out
    mov $1, %rdi
    lea num2(%rip), %rsi
    mov %rcx, %rdx #message len
    syscall
    jmp done

print_error:
    #print 'Invalid input'
    mov $1, %rax #system out
    mov $1, %rdi
    lea error_msg(%rip), %rsi
    mov $14, %rdx #message len
    syscall

done:
    mov $60, %rax
    mov $0, %rdi
    syscall
