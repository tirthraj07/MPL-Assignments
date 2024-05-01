%macro read %2
mov rax, 00
mov rdi, 00     ; stdin
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro write %2
mov rax, 01
mov rdi, 01     ; stdout
mov rsi, %1
mov rdx, %2
syscall
%endmacro


section .data
msg1 db "Enter Numbers",0xA,0xD
msg1len equ $-msg1

msg2 db "Your Numbers are",0xA,0xD
msg2len equ $-msg2

count db 05

section .bss
resultarr resb 85 ; 16*5 + 5

section .text
global _start
_start:


write msg1, msg1len

mov rbp, resultarr

loop1:
read [rbp], 17
add rbp, 17
dec byte[count]
jnz loop1


write msg2, msg2len
write resultarr, 85


;EndSyscall

mov rax, 60
mov rdi, 00
syscall