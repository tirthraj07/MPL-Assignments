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
str1 resb 25
resultarr resb 16
count resb 02

global _start
section .text
_start:
rw 1,msg1,msglen1	; Print the message "Enter String"
rw 0,str1,25		; Store the user input inside the variable str 
			; rax register will be modified to the length of the string
			; However we cannot directly print the rax as it will convert the value of rax to its ascii hex representation
			; Thus for all the digits in rax, we need to convert EACH digit to its ascii hex form
			; For example if rax contains 0000 0000 0000 0018 then we need to convert every 0 to 30h and 1 -> 31h and 8 ->38h				
			; 0-9 -> 30h to 39h and A-F -> 41h to 46h
			; Calculate 30h - 00h and 41h - 0Ah to get the difference
			; It will be 30h and 37h respectively
mov rbp, resultarr	; mov the base address of resultarr -> rbp
mov byte[count], 16	; Let count = 16 as rax -> Quad Word ____ ____ ____ ____

up:
rol rax,04		; Rotate the contents of rax by 4 bits
mov bl,al		; mov the lsb to bl
and bl,0Fh		; Mask the bl to get the last nibble
cmp bl,09h		; compare the lsb of rax -> bl with 09h
jle next		; if bl<=09h then add 30h else add 37h
add bl,07h		

next:
add bl,30h
mov [rbp],bl		; Store the content of bl inside address pointed by rbp
inc rbp		; increment rbp
dec byte[count]
jnz up

rw 01,msg2,msglen2	; Display "Length of string is"
rw 01,resultarr,16	; Display the length of string

mov rax,60		; End System call
mov rdi,00
syscall

