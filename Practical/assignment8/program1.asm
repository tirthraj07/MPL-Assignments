%macro rw 4
mov rax, %1
mov rdi, %2
mov rsi, %3
mov rdx, %4
syscall
%endmacro

section .data
fname db "abc.txt",0      ; Name of the file you want to read


; Print Statements
menu db 0xA,0xD"What do you want to do?",0xA,0xD
     db "1. Read number of spaces",0xA,0xD
     db "2. Read number of newlines",0xA,0xD
     db "3. Read number of occurances",0xA,0xD
     db "4. Exit",0xA,0xD
menuLen equ $-menu

fileOpenSuccessfullyMsg db "File Opened Successfully",0xA,0xD
fileOpenSuccessfullyMsgLen equ $-fileOpenSuccessfullyMsg

newline db 0xA,0xD
newlineLen equ $-newline

fileClosedSuccessfullyMsg db "File Closed Successfully",0xA,0xD
fileClosedSuccessfullyMsgLen equ $-fileClosedSuccessfullyMsg  

errorMsg db "There was an error opening the file",0xA,0xD
errorMsgLen equ $-errorMsg

countSpacesMsg db "No. of spaces in the file : "
countSpacesMsgLen equ $-countSpacesMsg

countNewlineMsg db "No. of newlines in the file : "
countNewlineMsgLen equ $-countNewlineMsg

askCharacterMsg db "Which character do you want to search"
askCharacterMsgLen equ $-askCharacterMsg 

countCharacterMsg db "No. of character in the file : "
countCharacterMsgLen equ $-countCharacterMsg

enterValidChoiceMsg db "Enter valid choice",0xA,0xD
enterValidChoiceMsgLen equ $-enterValidChoiceMsg

section .bss
fd resb 17               ; This will contain the address of the file descriptor

buffer resb 200       ; This will contain the actual file content (MAX 200bytes)

buffer_length resq 01       ; This will content the length of the file content

count1 resq 01      ; This will contain the same value as buffer length but will act as counters when we are iterating through the buffer in the external file
count2 resq 01
count3 resq 01


; variables required for menu driven code
choice resb 02      ; Actual Choice + Enter

section .text
global _start
_start:


; Open the file

file_open:
mov rax, 02         ; File Open (Read Mode) system call
mov rdi, fname
mov rsi, 02
mov rdx, 0777h
syscall


; Check the MSW of the rax after opening the file to see if the opening was successful
; If 63rd bit == 1 then unsuccessful
mov qword[fd], rax
bt rax, 63
JNC file_read
rw 01,01,errorMsg,errorMsgLen
jmp endsyscall

; Once the file was successfully opened, store the contents of rax (Address of file descriptor) in fd
file_read:
rw 01,01,fileOpenSuccessfullyMsg,fileOpenSuccessfullyMsgLen
rw 00,[fd],buffer,200       ; Read System Call

; After reading the string in the file, the rax is modified to the length of the string same as that in assignment 2

mov qword[buffer_length], rax
mov qword[count1], rax
mov qword[count2], rax
mov qword[count3], rax

menu_label:

rw 01,01,menu, menuLen
rw 00,00,choice,02

cmp byte[choice], '1'
jnz checkOption2

; Count spaces
rw 01,01,countSpacesMsg,countSpacesMsgLen

jmp menu_label

checkOption2:
cmp byte[choice], '2'
jnz checkOption3
; Count newline
rw 01,01,countNewlineMsg,countNewlineMsgLen

jmp menu_label

checkOption3:
cmp byte[choice], '3'
jnz checkOption4
; Count character
rw 01,01,countCharacterMsg, countCharacterMsgLen

jmp menu_label

checkOption4:
cmp byte[choice], '4'
jnz validChoiceError
jmp file_close


validChoiceError:
rw 01,01,enterValidChoiceMsg, enterValidChoiceMsgLen
jmp menu_label


; Close File 

file_close:
rw 01,01,fileClosedSuccessfullyMsg,fileClosedSuccessfullyMsgLen
mov rax, 03
mov rdi, [fd]
syscall

; Close Program

endsyscall:
mov rax, 60
mov rdi, 00
syscall