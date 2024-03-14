%macro rw 3
mov rax, %1
mov rdi, 1
mov rsi, %2
mov rdx, %3
syscall
%endmacro

section .data
result dq 00h
count db 05h
remainder dq 00h


msg1 db 10,13,"Welcome to Calculator App By Tirthraj Mahajan",10,13
msg1len equ $-msg1

msg2 db 10,13,"What do you want to do?",10,13,"1.Addition",10,13,"2.Subtraction",10,13,"3.Multiplication",10,13,"4.Division",10,13,"5.Exit",10,13,">> "
msg2len equ $-msg2

msg3 db 10,13,"Thank you for using Tirthraj's Calculator App",10,13
msg3len equ $-msg3

msg4 db 10,13,"Remainder: "
msg4len equ $-msg4

msg5 db 10,13,"Quotient: "
msg5len equ $-msg5


num1 dq 0Ah
num2 dq 03h

section .bss
resultarr resb 16
option resb 02

section .text
global _start
_start:


menu:
rw 01,msg1,msg1len
rw 01,msg2,msg2len
rw 00,option,02
cmp byte[option], 31h
jnz checkSub
call addProcedure
call htoa
jmp menu
checkSub:
cmp byte[option], 32h
jnz checkMul
call subtractProcedure
call htoa
jmp menu
checkMul:
cmp byte[option], 33h
jnz checkDiv
call multiplicationProcedure
call htoa
jmp menu
checkDiv:
cmp byte[option], 34h
jnz checkExit
call divisionProcedure
;call htoa
jmp menu
checkExit:
cmp byte[option], 35h
jnz menu
rw 01, msg3, msg3len

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

addProcedure:
mov rax, qword[num1]
add rax, qword[num2]
mov qword[result], rax
ret


subtractProcedure:
mov rax, qword[num1]
sub rax, qword[num2]
mov qword[result], rax
ret

multiplicationProcedure:
mov rax, qword[num1]
mov ecx, dword[num2]
mul ecx
mov qword[result], rax
ret

divisionProcedure:
xor rax,rax
xor rdx, rdx
xor rcx, rcx
mov rax, qword[num1]
mov ecx, dword[num2]
div ecx
mov qword[result], rax
mov qword[remainder], rdx
rw 01, msg5, msg5len
call htoa
rw 01, msg4, msg4len
mov rax, qword[remainder]
mov qword[result], rax
call htoa
ret
