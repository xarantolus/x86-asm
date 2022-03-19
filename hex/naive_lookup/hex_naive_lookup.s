.intel_syntax noprefix
.section .text

.global _start

_start:
    .Lread_start:
    mov rax, 0 # Read
    mov rdi, 0 # From Stdin
    lea rsi, [rip+char] # To char
    mov rdx, 1 # one byte
    syscall

    lea r11, [rip+lookup_table]

    # Error handling: reading <= 0 bytes is an error
    cmp rax, 0
    JLE .Lloop_end

    mov al, [rip+char]
    mov bl, al

    and al, 0b1111
    shr bl, 4

    mov al, [r11+rax]
    mov bl, [r11+rbx]

    # Switch the bytes around due to endianness
    mov [output+1], al
    mov [output], bl

    .Ljust_write:
    mov rax, 1 # Write
    mov rdi, 1 # To stdout
    lea rsi, [rip+output] # from char
    mov rdx, 2 # two bytes
    syscall

    JMP .Lread_start

    .Lloop_end:


    mov rax, 1 # Write
    mov rdi, 1 # To stdout
    lea rsi, [rip+newline]
    mov rdx, 1 # one byte
    syscall

    mov rax, 60 # Exit system call
    mov rdi, 0 # Error code

    syscall


.section .data
lookup_table:
.ascii "0123456789abcdef"

output:
.space 2

char: .space 1

newline: .ascii "\n"
