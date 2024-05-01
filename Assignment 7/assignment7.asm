%macro rw 3
mov rax, %1
mov rdi, 1
mov rsi, %2
mov rdx, %3
syscall
%endmacro

section .data
sarr dq 54h,22h,10h, 4Eh, 2Ah
darr dq 00h,00h,00h
msg1 db " : "
msglen1 equ $-msg1
msg2 db 0Ah,0Dh
msglen2 equ $-msg2

msg3 db "Before",0xA,0xD
msg3len equ $-msg3

msg4 db "After",0xA,0xD
msg4len equ $-msg4

result dq 00h
count db 16h
cnt dw 05h

section .bss
resultarr resb 16

section .text
global _start
_start:

rw 01, msg3, msg3len

mov rsi, sarr
labelForPrint1:
mov qword[result], rsi
push rsi
call htoa  
rw 01,msg1,msglen1
pop rsi
mov rax,[rsi]
mov qword[result],rax
push rsi
call htoa
rw 01,msg2,msglen2
pop rsi
add rsi,08h
dec byte[cnt]
jnz labelForPrint1

mov byte[cnt],05h
xor rcx, rcx
mov cl, byte[cnt]
mov rsi, sarr+32
mov rdi, darr+16
std
rep movsq

push rdi

rw 01, msg4, msg4len

pop rdi

add rdi, 08h



labelForPrint2:
mov qword[result], rdi
push rdi
call htoa  
rw 01,msg1,msglen1
pop rdi
mov rax,[rdi]
mov qword[result],rax
push rdi
call htoa
rw 01,msg2,msglen2
pop rdi
add rdi,08h
dec byte[cnt]
jnz labelForPrint2

mov rax, 60
mov rdi, 00
syscall


htoa:
mov rax, qword[result]
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