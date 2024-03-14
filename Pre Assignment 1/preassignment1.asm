section .data
num db 2ch
section .bss
sum resb 1
global _start
section .text
_start:
mov rax,0fd19200532879bcdh
xy:
mov rax,60
mov rdi,00
syscall
