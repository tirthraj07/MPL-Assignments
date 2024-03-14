section .data
msg db "Hello World!",0xA,0xD
msglen equ $-msg
count db 0Ah

global _start
section .text
_start:
loop:
mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,msglen
syscall
dec byte[count]
jnz loop


mov rax,60
mov rdi,0
syscall

