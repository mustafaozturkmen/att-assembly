.section .data
buffer: .space 100

.section .text
.global _start

len_of_rsi:
    movb (%rsi), %al #al = pointed char
    cmp $0, %al # if %al is null then end of the string
    je done_method # jump to done
    inc %rcx # increase len
    inc %rsi # move to next char
    jmp len_of_rsi

upper:
    movb (%rsi), %al #put the chat to %al
    inc %rsi #make %rsi ready to jumps
    cmp $0, %al #if it is end jump to done
    je done_method
    cmp $'a', %al 
    jl upper #less than char 'a', not a lower-case char
    cmp $'z', %al
    jg upper #higher than char 'z', not a lower-case char 
    dec %rsi #fix %rsi for make the char upper case
    # %al = %al + (lower_upper_diff) = %al + upper - lower
    subb $'a', %al
    addb $'A', %al
    movb %al, (%rsi)
    inc %rsi #next char
    jmp upper

done_method:
    ret

_start:
    # Read input 
    xor %rdi, %rdi # read
    lea buffer(%rip), %rsi # buffer address
    mov $100, %rdx # message length
    xor %rax, %rax # stdin
    syscall

    # make all upper cases
    lea buffer(%rip), %rsi #first argument off upper method is %rsi 
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
