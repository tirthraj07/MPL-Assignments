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

message1 db "Entered Number is :"
message1len equ $-message1

message2 db 0Ah,0Dh,"Factorial of the number in hexadecimal is: "
message2len equ $-message2

count db 02h ; Since we are accepting a 2 digit number. 
num db 00h ; This will contain the number for which we have to find the factorial of
result db 00h

section .bss
basePtr resq 00h
resultarr resb 02

section .text
global _start
_start:

pop rbx ; This gives the number of arguments which are stored at the top of the stack
cmp rbx, 02
jnz errorLabel

pop rbx ; This contains the file which is executing as it is the first argument which is passed implicitly
pop rbx ; This will contain the number of which we want to find the factorial of
rw 01, message1, message1len
rw 01, rbx, 02
; However the number is not in hex but in ASCII. Thus we need to convert the ASCII number (It is stored in an array) to Hex

mov qword[basePtr], rbx
mov rsi, qword[basePtr] ; This will move the base address of the array containing the ascii number to rsi register

mov byte[count], 02
mov dl, 00h

; ASCII to HEX

repeatLabel:
rol dl, 04
mov bl, [rsi]
cmp bl, 39h
jbe skip
sub bl, 07h
skip:
sub bl, 30h
add dl, bl
inc rsi
dec byte[count]
jnz repeatLabel

; We can expect the number to be stored in count variable


mov byte[count], dl
rw 01, message2, message2len
mov al, byte[count]
dec byte[count]

fac:
mul byte[count]
dec byte[count]
cmp byte[count],01
jne fac

mov byte[result],al


call htoa


jmp endSysCall

errorLabel:
rw 01,errMessage,errMessageLen

endSysCall:
mov rax, 60
mov rdi, 00
syscall


htoa:
mov al, byte[result]
mov byte[count],2
mov rbp,resultarr
label1:
rol al,04
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
rw 01,resultarr,02
ret
