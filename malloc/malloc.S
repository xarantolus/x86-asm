.intel_syntax noprefix

.section .data
data_page_current_offset: .8byte 0
data_section_begin:

.section .text
malloc:
    // rdi (input):  number of bytes to allocate
    // rax (output): pointer to first byte of allocated memory or 0 on error

    push rbx
    push r12

    // First of all get the start address of our data section
    lea rax, [rip+data_section_begin]
    // Now add the current offset
    add rax, [rip+data_page_current_offset]

    // Save the previous program break
    mov r12, rax

    // Add the newly needed bytes
    add rax, rdi

    // Also save a new current offset (old offset + newly allocated bytes)
    add [rip+data_page_current_offset], rdi

    mov rbx, rdi
    // rdi is the argument for the syscall, so rax currently is the largest address we need
    mov rdi, rax

    // call brk syscall to increase data section
    mov rax, 0x0c
    syscall

    // Now see if the syscall returned a new, larger program break (success)
    cmp rax, r12
    JG .Lsuccess

.Lfailure:
    // It seems like an error happened. Restore our previous state by decrementing our offset
    // again. We saved rbx for that
    sub [rip+data_page_current_offset], rbx

    // Return null pointer
    mov rax, 0
    JMP .Lcleanup_malloc
.Lsuccess:
    sub rax, rbx
    sub rax, 1

.Lcleanup_malloc:
    pop r12
    pop rbx
    ret


.global _start
_start:
    mov rdi, 0x200
    call malloc

    mov byte ptr [rax+0x1ff], 20

    mov rax, 60
    mov rdi, 1
    syscall
