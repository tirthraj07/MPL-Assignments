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

%macro endsyscall 0
mov rax, 60
mov rdi, 00
syscall
%endmacro

section .data
num dq 00h
count db 00h
cnt db 00h

menu db "What do you want to do?",0xA,0xD
     db "1. Overlapping using movsq",0xA,0xD
     db "2. Non-Overlapping without movsq",0xA,0xD
menulen equ $-menu

sarrOverlapp dq 10h,20h,30h,40h,50h
darrOverlapp dq 00h,00h,00h

sarrNonOverlapp dq 100h,200h,300h,400h,500h
darrNonOverlapp dq 00h,00h,00h,00h,00h

beforeMsg db "Before:",0xA,0xD
beforeMsgLen equ $-beforeMsg

afterMsg db "After:",0xA,0xD
afterMsgLen equ $-afterMsg

colon db " : "
colonLen equ $-colon

newline db 0xA,0xD
newlineLen equ $-newline

section .bss
numarr resb 16
choice resb 02

section .text
global _start
_start:

write menu, menulen
read choice, 02

cmp byte[choice], '1'
jnz check2
call choice1
jmp _start

check2:
cmp byte[choice], '2'
jnz endprogram
call choice2
jmp _start

endprogram:
endsyscall

htoa:
mov rax, qword[num]
mov rbp, numarr
mov byte[count], 16h

loop1:
rol rax, 04
mov bl, al
and bl, 0Fh
cmp bl, 09h
jbe next
add bl, 07h
next:
add bl, 30h
mov [rbp], bl
inc rbp
dec byte[count]
jnz loop1

write numarr, 16

ret


choice1:
write beforeMsg, beforeMsgLen
mov rsi, sarrOverlapp
mov byte[cnt], 05h

up1:
mov rax, rsi
mov qword[num], rax
push rsi
call htoa
pop rsi
mov rax, [rsi]
mov qword[num], rax
push rsi
write colon, colonLen
call htoa
write newline, newlineLen
pop rsi
add rsi, 08h
dec byte[cnt]
jnz up1

mov byte[cnt], 05h
xor rcx, rcx
mov cl, byte[cnt]
mov rsi, sarrOverlapp+32
mov rdi, darrOverlapp+16
std
rep movsq

push rdi

write afterMsg, afterMsgLen

pop rdi
add rdi, 08h

mov byte[cnt], 05h
up2:
mov rax, rdi
mov qword[num], rax
push rdi
call htoa
pop rdi
mov rax, [rdi]
mov qword[num], rax
push rdi
write colon, colonLen
call htoa
write newline, newlineLen
pop rdi
add rdi, 08h
dec byte[cnt]
jnz up2


ret

choice2:
write beforeMsg, beforeMsgLen
mov rsi, sarrNonOverlapp
mov byte[cnt], 05h

up3:
mov rax, rsi
mov qword[num], rax
push rsi
call htoa
pop rsi
mov rax, [rsi]
mov qword[num], rax
push rsi
write colon, colonLen
call htoa
write newline, newlineLen
pop rsi
add rsi, 08h
dec byte[cnt]
jnz up3

mov rsi, sarrNonOverlapp
mov rdi, darrNonOverlapp
mov byte[cnt], 05h
up4:
mov rax, [rsi]
mov [rdi], rax
add rsi, 08h
add rdi, 08h
dec byte[cnt]
jnz up4

write afterMsg, afterMsgLen

mov rdi, darrNonOverlapp
mov byte[cnt], 05h

up5:
mov rax, rdi
mov qword[num], rax
push rdi
call htoa
pop rdi
mov rax, [rdi]
mov qword[num], rax
push rdi
write colon, colonLen
call htoa
write newline, newlineLen
pop rdi
add rdi, 08h
dec byte[cnt]
jnz up5

ret