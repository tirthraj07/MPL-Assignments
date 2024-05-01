%macro rw 3
mov rax, %1
mov rdi, %1
mov rsi, %2
mov rdx, %3
syscall
%endmacro

section .data
num db 00h
count db 16h
arr dq -10d, 20d, 30d, -40d, -50d 
pcount db 00
ncount db 00
msg1 db "Number of positive numbers are :"
msg1len equ $-msg1

msg2 db "Number of negative numbers are :"
msg2len equ $-msg2

newLine db 0xA,0xD
newLineLen equ $-newLine

section .bss
numarr resb 02


section .text
global _start
_start:

mov byte[count], 05
mov rbp, arr

up:
mov rax, [rbp]
bt rax, 63
jc negative
inc byte[pcount]
jmp next1
negative:
inc byte[ncount]
next1:
add rbp,08
dec byte[count]
jnz up

rw 01, msg1, msg1len
mov al, byte[pcount]
mov byte[num], al
call htoa

rw 01, newLine, newLineLen

rw 01, msg2, msg2len
mov al, byte[ncount]
mov byte[num], al

call htoa

rw 01, newLine, newLineLen


mov rax, 60
mov rdi, 00
syscall

htoa:
mov al, byte[num]
mov byte[count], 02
mov rbp, numarr

loop1:
rol al, 04
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

rw 01, numarr, 02
ret

