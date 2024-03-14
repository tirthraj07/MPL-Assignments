%macro rw 3
mov rax,%1
mov rdi,1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

; In this assigment, we need to store an array of 5 quad word numbers. So we have declared arr as dq with 5 Quad Word Number
; To iterate through this array, we have declared a count variable with value 05h
; To store the number of positive numbers, we have declared pcount and to store negative numbers, we have declared ncount
; Now move the base address of arr to rbp
; Move the contents of address stored in rbp [rbp] into rax
; Now bit test the 63th bit of rax to check if rax is negative or positive
; If bit = set then negative and bit = reset then positive. For that, check carry flag
; Then we will increment the ncount and pcount respectively
; To display ncount and pcount, we need to convert hextoascii, for that, we will use the logic of assigment 2 inside a procedure htoa
; Note, will calling the procedure, the registers are stacked, thus we need to store the pcount and ncount inside another temporary variable, we cannot directly use al	


section .data
arr dq 7F276ABC76594C2Bh, 12DEACBF721E1211h, 0FFFF1233061A8888h, 1F89111122224444h, 1141122223333444h
count db 05h
pcount db 00h
ncount db 00h
res db 00h
msg1 db 0Ah,0Dh,"Total Positive Numbers are: "
msglen1 equ $-msg1
msg2 db 0Ah,0Dh,"Total Negative Numbers are: "
msglen2 equ $-msg2

resultarr db 00h,00h

section .bss


section .text
global _start
_start:

mov rbp, arr

up:
mov rax,[rbp]
bt rax,63
JC negative
inc byte[pcount]
jmp next
negative:
inc byte[ncount]
next:
add rbp,08
dec byte[count]
JNZ up


rw 01,msg1,msglen1
mov al,byte[pcount]
mov byte[res],al
call htoa

rw 01,msg2,msglen2
mov al,byte[ncount]
mov byte[res],al
call htoa


mov rax,60
mov rdi,00
syscall

htoa:
mov al, byte[res]
mov byte[count],02
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



