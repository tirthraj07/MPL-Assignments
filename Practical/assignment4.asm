%macro rw 3
mov rax, %1
mov rdi, %1
mov rsi, %2
mov rdx, %3
syscall
%endmacro

section .data
num dq 00h
count db 00h

arr dq 10h,20h,30h,40h,50h

section .bss
numarr resb 16

section .text
global _start
_start:

mov byte[count], 05
mov rbp, arr
xor rax, rax
mov rax, [rbp]

up:
cmp rax, [rbp]
jae skip
mov rax, [rbp]
skip:
add rbp, 08h
dec byte[count]
jnz up

mov qword[num], rax
call htoa


mov rax, 60
mov rdi, 00
syscall

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
rw 01, numarr, 16
ret