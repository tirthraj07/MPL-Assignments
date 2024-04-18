%macro rw 3
mov rax, %1
mov rdi, 1
mov rsi, %2
mov rdx, %3
syscall
%endmacro


section .data
count db 16h

section .bss
resultarr resb 16

section .text
global htoa
extern result

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
