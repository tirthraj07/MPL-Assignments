%macro rw 3
mov rax, %1
mov rdi, 1
mov rsi, %2
mov rdx, %3
syscall
%endmacro


section .data
arr dq 7F276ABC76594C2Bh, 12DEACBF721E1211h, 0FFFF1233061A8888h, 1F89111122224444h, 1141122223333444h
count db 05h
largest dq 0000000000000000h

msg1 db "Largest Number is : "
msglen1 equ $-msg1

section .bss
resultarr resb 16

section .text
global _start
_start:

mov rbp, arr
mov rax, [rbp]
mov qword[largest], rax

up:
mov rax, [rbp]
cmp qword[largest],rax
jp next
mov qword[largest],rax
next:
add rbp,08h
dec byte[count]
jnz up

rw 01, msg1, msglen1
mov rax, largest
call htoa

mov rax,60
mov rdi,00
syscall

htoa:
mov rax, qword[largest]
mov byte[count],16
mov rbp,resultarr


label1:
rol rax,04
mov bl,al
and bl,0Fh
cmp bl,09h
jle label2
add bl,07h
label2:
add bl,30h
mov [rbp],bl
inc rbp
dec byte[count]
jnz label1
rw 01,resultarr,16
ret

