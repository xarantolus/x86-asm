# 1 "malloc.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "malloc.S"
.intel_syntax noprefix

.section .data
data_section_begin:
data_page_current_offset: .8byte 0

.section .text
malloc:



    push rbx


    lea rax, [rip+data_section_begin]

    add rax, 8

    add rax, [rip+data_page_current_offset]


    add [rip+data_page_current_offset], rdi

    mov rbx, rdi

    mov rdi, rax


    mov rax, 0x0c
    syscall


    cmp rax, 0
    JZ .Lcleanup_malloc



    sub [rip+data_page_current_offset], rbx

.Lcleanup_malloc:
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
