%macro read 2
mov rax, 00
mov rdi, 00
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro write 2
mov rax, 01
mov rdi, 01
mov rsi, %1
mov rdx, %2
syscall
%endmacro

section .data
num1 dq 0Ah
num2 dq 05h
result dq 01
count db 16
quotient dq 00
remainder dq 00

menu db  0xA,0xD,"What do you want to do?",0xA, 0xD
     db "1. Addition",0xA, 0xD
     db "2. Subtraction",0xA, 0xD
     db "3. Multiplication",0xA, 0xD
     db "4. Division",0xA, 0xD
     db "5. Exit",0xA, 0xD
menulen equ $-menu

errorMessage db "Please Enter a valid choice",0xA, 0xD
errorMessageLen equ $-errorMessage

quotientMessage db "Quotient is: "
quotientMessageLen equ $-quotientMessage

remainderMessage db "Remainder is: "
remainderMessageLen equ $-remainderMessage

thankyouMessage db "Thanks for using",0xA, 0xD
thankyouMessageLen equ $-thankyouMessage

newLine db 0xA,0xD
newLineLen equ $-newLine


section .bss
numarr resb 16
choice resb 02 ; Actual Choice + Enter Key

section .text
global _start
_start:

write menu, menulen
read choice, 02

cmp byte[choice], 31h
jnz checksub
call addProcedure
call htoa
jmp _start

checksub:

cmp byte[choice], '2'
jnz checkmul
call subProcedure
call htoa
jmp _start

checkmul:
cmp byte[choice], '3'
jnz checkdiv
call mulProcedure
call htoa
jmp _start

checkdiv:
cmp byte[choice], '4'
jnz checkexit
call divProcedure
call htoa
jmp _start

checkexit:
cmp byte[choice], '5'
jz endSyscall

write errorMessage, errorMessageLen
jmp _start


endSyscall:
write thankyouMessage, thankyouMessageLen
mov rax, 60
mov rdi, 00
syscall

htoa:
mov rax, qword[result]
mov byte[count], 16
mov rbp, numarr

loop1:
rol rax, 04
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
write numarr, 16
ret


addProcedure:
mov rax, qword[num1]
add rax, qword[num2]
mov qword[result], rax
ret

subProcedure:
mov rax, qword[num1]
sub rax, qword[num2]
mov qword[result], rax
ret

mulProcedure:
mov rax, qword[num1]
mov ebx, dword[num2]
mul ebx
mov qword[result], rax
ret

divProcedure:
xor rax, rax
xor rdx, rdx
xor rbx, rbx
mov rax, qword[num1]
mov ebx, dword[num2]
div ebx
mov qword[quotient], rax
mov qword[remainder], rdx
write quotientMessage, quotientMessageLen
mov rax, qword[quotient] 
mov qword[result], rax
call htoa
write newLine, newLineLen
write remainderMessage, remainderMessageLen
mov rax, qword[remainder] 
mov qword[result], rax
ret
