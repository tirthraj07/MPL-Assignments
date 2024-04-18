section .data
result dq 103576h

section .bss

section .text
global result
global _start
_start:
extern htoa
call htoa

	
mov rax, 60
mov rdi, 00
syscall
