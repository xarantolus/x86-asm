.intel_syntax noprefix

.section .text
malloc:
    // rdi (input):  number of bytes to allocate
    // rax (output): pointer to first byte of allocated memory or 0 on error

    push rbx
    push r12

    // Save the number of bytes to allocate in rbx
    mov rbx, rdi

    // Call the brk(0) syscall to get current program break (basically end of heap?)
    mov rdi, 0
    mov rax, 0xc
    syscall

    // Save previous break
    mov r12, rax

    // Now do the same thing again, but we call it with the increased size we want
    add rax, rbx

    // Get the new page break
    mov rdi, rax
    mov rax, 0xc
    syscall

    // if we got the same break, allocation failed
    cmp r12, rax
    JE .Lfail

    // Now rax contains the end of our program break
    // We can subtract rbx and return that pointer, as now we can write `rbx` many bytes
    // One thing to note here is that `brk` can give us much more than we wanted, but
    // for ease of use we can also just do nothing and waste a lot of memory
    sub rax, rbx

    JMP .Lcleanup_malloc
.Lfail:
    mov rax, 0

.Lcleanup_malloc:
    pop r12
    pop rbx
    ret


.global _start
_start:
    mov rdi, 200
    call malloc

    mov byte ptr [rax+200], 20

    mov rax, 60
    mov rdi, 1
    syscall
