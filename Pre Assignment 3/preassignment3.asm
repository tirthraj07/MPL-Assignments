%macro rw 3
mov rax,%1
mov rdi,0
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
msg1 db "Enter Number",0xA,0xD
msglen1 equ $-msg1
msg2 db "Your No is "
msglen2 equ $-msg2
count db 0Ah

section .bss
num resb 16

global _start
section .text
_start:
loop:
rw 1,msg1,msglen1
rw 0,num,16
rw 1,msg2,msglen2
rw 1,num,16
dec byte[count]
jnz loop

mov rax,60
mov rdi,00
syscall
