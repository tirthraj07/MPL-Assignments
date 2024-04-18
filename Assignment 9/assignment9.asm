%macro rw 3
mov rax, %1
mov rdi, 1
mov rsi, %2
mov rdx, %3
syscall
%endmacro

section .data

errMessage db "Error: Required 2 Arguments not satisfied",0Ah,0Dh
errMessageLen equ $-errMessage

count db 02h ; Since we are accepting a 2 digit number. 
num db 00h ; This will contain the number for which we have to find the factorial of

section .bss
basePtr resq 00h

section .text
global _start
_start:

pop rax ; This gives the number of arguments which are stored at the top of the stack
cmp rax, 02
jnz errorLabel

pop rax ; This contains the file which is executing as it is the first argument which is passed implicitly
pop rax ; This will contain the number of which we want to find the factorial of

; However the number is not in hex but in ASCII. Thus we need to convert the ASCII number (It is stored in an array) to Hex

mov qword[basePtr], rax
mov rsi, qword[basePtr] ; This will move the base address of the array containing the ascii number to rsi register
mov byte[count], 02
mov dl, 00h

; ASCII to HEX

repeatLabel:
rol dl, 04
mov al, [rsi]
cmp al, 39h
jbe skip
sub al, 07h
skip:
sub al, 30h
add dl, al
inc rsi
dec byte[count]
jnz repeatLabel

; We can expect the number to be stored in num variable

xy:
mov byte[num], dl

rw 01,num,01 


jmp endSysCall

errorLabel:
rw 01,errMessage,errMessageLen

endSysCall:
mov rax, 60
mov rdi, 00
syscall
