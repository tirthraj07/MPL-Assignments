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
msg2 db "Num : "
msglen2 equ $-msg2
count db 05

section .bss
numarr resb 85; 16*5 + 5 "Enter"


global _start
section .text
_start:

mov byte[count],05
mov rbp,numarr

loop1:
rw 1,msg1,msglen1
rw 0,rbp,17
add rbp,17
dec byte[count]
jnz loop1

mov byte[count],05
mov rbp,numarr

loop2:
rw 1,msg2,msglen2
rw 1,rbp,17
add rbp,17
dec byte[count]
jnz loop2

mov rax,60
mov rdi,00
syscall

