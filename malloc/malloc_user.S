.intel_syntax noprefix

.section .text
.global _start
_start:
    // Allocate 28 bytes (alphabet + \n + 0-terminator)
    mov rdi, 28
    call some_kind_of_malloc

    // Save start ptr of string
    mov r12, rax

    mov cl, 'a'
.Lloop_start:
    mov byte ptr [rax], cl

    // Increase ptr
    inc rax
    // Get next char
    inc cl
    // Make sure we're still in range
    cmp cl, 'z'
    JLE .Lloop_start

    // Add a '\n' at the end
    mov byte ptr [rax], '\n'
    // 0-terminate string
    mov byte ptr [rax+1], 0


    // Now we can output this string, starting at r12
    mov rax, 1 // write
    mov rdi, 1 // Stdout
    mov rsi, r12 // buf ptr
    mov rdx, 27 // length
    syscall


    // Exit code 0
    mov rax, 60
    mov rdi, 0
    syscall
