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

result dq 00h
count db 16h
cnt dw 05h

section .bss
resultarr resb 16

section .text
global _start
_start:

mov rsi, sarr
labelForPrint1:
mov qword[result], rsi
push rsi
call htoa  ;i am getting error here
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

mov cx, word[cnt]
mov rsi, sarr+32
mov rdi, darr+16
std
rep movsq
	
	
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
