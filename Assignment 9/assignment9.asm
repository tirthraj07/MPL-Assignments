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
hex_num db 00h
count db 00h
basePtr dq 00h

errorMessage db "2 Command Line Arguments Required",0xA,0xD
errorMessageLen equ $-errorMessage

msg1 db "To Find Factorial of : "
msg1len equ $-msg1

newline db 0xA,0xD
newlineLen equ $-newline

section .bss
numarr resb 16

section .text
global _start
_start:

; In this assignment we need to take the input from command line and then find the factorial of that number and display it on the console
; Step 1: Obtain the ASCII Number entered by the user
; Step 2: Convert the ASCII number to hex number
; Step 3: Recursively Find the factorial of that number using stack manipulation
; Step 4: Reconvert the hex answer to ASCII to print it on the screen


; Step 1.
pop rax    ; Now rax contains the number of argument that are given through command line

; Check if the number of arguments are 2 
; 1st is the output file name (Passed Implicitly)
; 2nd is the number we want to find the factorial of


cmp rax, 02h
jnz displayErrorMessage

pop rax
pop rax     ; Now rax contains the address of the memory location containing the ASCII form of the number

mov qword[basePtr], rax

write msg1, msg1len
write [basePtr], 02
write newline, newlineLen

; call ascii to hex
call atoh
xor rax, rax
mov al , byte[hex_num]  ; Now al contains the hex number of which we want to find the factorial of
call factorial



jmp endprogram

displayErrorMessage:
write errorMessage, errorMessageLen


endprogram:
endsyscall



factorial:
cmp rax, 01h
je checkpoint1
push rax
dec rax
call factorial      ; Return address will point to here

; Explanation of what is happening in this code
; Suppose rax has 05 value
; initially we are comparing whether al if 01 or not. That is our base condition
; If now, then we insert the value onto the stack
; then we call factorial procedure again.
; when we do call the procedure, the address of the memory location from where we called is stored on top of stack
; Thus till rax = 01, the stack will look like following
; 05, return address, 04, return address, 03, return address, 02, return address
; Then we move to checkpoint 1


checkpoint2:
pop ebx     ; Now we pop the value from the stack (Not the return address) and store it inside rbx


checkpoint1:
pop rbx     ; we remove the return address from the top of the stack
jmp checkpoint2


ret



htoa:
mov rax, qword[num]
mov rbp, numarr
mov byte[count], 16

loop1:
rol rax, 04
mov bl, al
and bl, 0Fh
cmp bl, 09h
jbe next1
add bl, 07h
next1:
add bl, 30h
mov [rbp], bl
inc rbp
dec byte[count]
jnz loop1
write numarr, 16
ret


atoh:
mov rbp, [basePtr]
xor rdx, rdx
mov byte[count], 02

loop2:
rol bl, 04
mov dl, [rbp]
cmp dl, 39h
jbe next2
sub dl, 07h
next2:
sub dl, 30h
add bl, dl
inc rbp
dec byte[count]
jnz loop2
mov byte[hex_num], bl
ret