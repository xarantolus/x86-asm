.intel_syntax noprefix

.section .rodata
error_allocating_memory: .asciz "Error while allocating memory\n"
error_allocating_memory_len: .8byte 30

.section .text
print_memory_error:
    mov rax, 1 // write
    mov rdi, 1 // Stdout
    lea rsi, [rip+error_allocating_memory] // buf
    mov rdx, [rip+error_allocating_memory_len] // length
    syscall

    // Exit with exit code 42
    mov rax, 60
    mov rdi, 42
    syscall


// This is absolutely not malloc, but it is a very minimal memory
// Allocation wrapper. It works by increasing the "program break",
// which is the heap of the program. It returns a pointer to the beginning
// of the section you can write to the number of bytes you requrested in
// rdi. The section returned may be writable even after it, but just don't do that, ok?
// Also, this implementation exists the program on errors
.global some_kind_of_malloc
some_kind_of_malloc:
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
    // Make sure we align our pointer to 16 bytes; calling convention
    sub rsp, 8
    call print_memory_error

    // This part is never reached as print_memory_error exits

.Lcleanup_malloc:
    pop r12
    pop rbx
    ret
