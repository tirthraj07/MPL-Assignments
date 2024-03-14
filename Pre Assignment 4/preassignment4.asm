%macro rw 3
mov rax,%1
mov rdi,1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
msg1 db "Enter String",0Ah,0Dh
msglen1 equ $-msg1
msg2 db "Length of String is: "
msglen2 equ $-msg2

section .bss
len resb 01
str1 resb 25

global _start
section .text
_start:
rw 1,msg1,msglen1	; Print the message "Enter String"
rw 0,str1,25		; Store the user input inside the variable str 
rw 1,str1,25

mov rax,60		; End System call
mov rdi,00
syscall

