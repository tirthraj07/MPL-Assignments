%macro read 2
mov rax, 00
mov rdi, 00
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro write 2
mov rax, 01
mov rdi, 01
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro endsyscall 0
mov rax, 60
mov rdi, 00
syscall
%endmacro

section .data
num dq 00h
count db 16

msg1 db "Enter String",0xA
msg1len equ $-msg1

msg2 db "Length of the String is",0xA
msg2len equ $-msg2

section .bss
numarr resb 16
str1 resb 50

section .text
global _start
_start:

write msg1,msg1len
read str1,50

mov qword[num], rax
write msg2, msg2len
call htoa

endsyscall


htoa:
mov rax, qword[num]
mov byte[count], 16
mov rbp, numarr

loop1:
rol rax, 04
mov bl, al
and bl, 0Fh
cmp bl, 09h
jle next
add bl, 07h
next:
add bl, 30h
mov [rbp], bl
inc rbp
dec byte[count]
jnz loop1

write numarr, 18
ret