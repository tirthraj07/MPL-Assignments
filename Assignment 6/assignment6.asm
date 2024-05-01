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
realModeMsg db "Processor is in Real Mode"
realModeMsgLen equ $-realModeMsg

protectedModeMsg db "Processor is in Protected Mode"
protectedModeMsgLen equ $-protectedModeMsg

gdtContentsMsg db "GDT Contents are : "
gdtContentsMsgLen equ $-gdtContentsMsg

ldtContentsMsg db "LDT Contents are : "
ldtContentsMsgLen equ $-ldtContentsMsg 

idtContentsMsg db "IDT Contents are : "
idtContentsMsgLen equ $-idtContentsMsg

taskRegisterMsg db "Task Register Contents are: "
taskRegisterMsgLen equ $-taskRegisterMsg

cr0ContentsMessage db "CR0 / MSW Contents are : "
cr0ContentsMessageLen equ $-cr0ContentsMessage

cpuidContentsMessage db "CPU ID : "
cpuidContentsMessageLen equ $-cpuidContentsMessage

nl db 0xA,0xD
nl_len equ $-nl

colon db " : "
colonLen equ $-colon

num dw 00h
count db 00h

section .bss
numarr resb 04

cr0_contents resb 04        ; 32 bits -> 4 bytes
gdt_contents resb 06        ; 48 bits -> 6 bytes
ldt_contents resb 02        ; 16 bits -> 2 bytes
idt_contents resb 06        ; 48 bits -> 4 bytes
tr_contents resb 02         ; 16 bits -> 2 bytes
cpuid_contents resb 12

section .text
global _start
_start:

; Pre-requisites
; 1 bytes - 8bits
; 1 word - 16bits
; 1 dword - 32bits
; 1 qword - 64bits

; CRO - 32 bit
; GDT - 48 bits
; IDT - 48 bits
; LDT - 16 bits
; TR (visible portion) - 16bits

; al - 8 bits 
; ax - 16 bits
; eax - 32 bits
; rax - 64 bits

; If you can notice, the CRO,GDT,IDT,etc are all divisible by 16. Meaning that we can store their contents in ax, bx, cx and so on
; Therefore, we must modify the htoa we have been writing display word rather than qword
; Thus num -> define word, count -> 04 (since 4 digits in word) and numarr -> 4 bytes (since we need 4 bytes to store 4 digits in ascii)

; Step1: First we need to check if the system is in protected mode
; To do so, we need to check the msw (Machine Status Word) which is CR0
; We need to check if the 0th bit is 1/0 which is the PE bit (Protection Enabled)
; Now CR0 is 32 bit register, which means that we need 4 bytes
; Thus reserve a variable cr0_contents which is 4 bytes
; We will initially store the contents of cr0 in register eax and then move the contents to cr0_contents
; Use store machine status word instruction for this purpose

smsw eax
mov dword[cr0_contents], eax
bt eax, 0
; Check the PE bit
JC protectedMode
; PE = 0 means Real Mode
write realModeMsg, realModeMsgLen
endsyscall
; PE = 1 means Protected Mode
protectedMode:
write protectedModeMsg, protectedModeMsgLen

; new line
write nl, nl_len

; Now display the contents of CR0
write cr0ContentsMessage, cr0ContentsMessageLen
mov ax, word[cr0_contents+2]
mov word[num], ax
call htoa

mov ax, word[cr0_contents]
mov word[num], ax
call htoa

; new line
write nl, nl_len


; Step 2: Display The GDT Contents
; GDTR is 48 bits, so you need to reserve 6 bytes of memory to store its contents
; You can directly store that in the gdt_contents
; Use store gtd instruction 


write gdtContentsMsg, gdtContentsMsgLen
sgdt [gdt_contents]
mov ax, word[gdt_contents+4]
mov word[num], ax
call htoa
mov ax, word[gdt_contents+2]
mov word[num], ax
call htoa
write colon, colonLen
mov ax, word[gdt_contents]
mov word[num], ax
call htoa

; new line
write nl, nl_len


; Step 3: Display the IDT
; IDTR is 16 bit as it contents the offset at which the ldt descriptors are stored in the GDT
; Thus base Address of GDT (Using GDTR) + offset (Using LDTR) -> location of the ldt descriptors which in turn provide the location of LDT
; Thus we need to store 16 bit address -> 2 bytes
; Use store ldt instruction for that purpose

write ldtContentsMsg, ldtContentsMsgLen
sldt [ldt_contents]
mov ax, word[ldt_contents]
mov word[num], ax
call htoa

; new line
write nl, nl_len

; Step 4: Display the IDT
; Like GDTR, IDTR is also 48 bits. Therefore we need 6 bytes to store the idtr contents
; Use store idt instruction for that purpose

write idtContentsMsg, idtContentsMsgLen

sidt [idt_contents+4]
mov ax, word[idt_contents]
mov word[num], ax
call htoa

sidt [idt_contents+2]
mov ax, word[idt_contents]
mov word[num], ax
call htoa

write colon, colonLen

sidt [idt_contents]
mov ax, word[idt_contents]
mov word[num], ax
call htoa

; new line
write nl, nl_len

; Step 5: Display Task Register
; Task Register is used to located the TSS using the TSS Descripter stored in the GDT
; It is divided in two portions, visible and invisible
; Visible portion of the Task Register is of 16 bits which contents the offset similar to IDTR
; Invsible portion of the Task Register contains the base address of the TSS and Limit which is stored in catche for efficient retrival of the location of TSS
; We can only read the visible portion
; Thus we need to store 16 bit space which is 2 bytes of space
; We can use show tr instruction for this purpose

write taskRegisterMsg, taskRegisterMsgLen

str [tr_contents]
mov ax, word[tr_contents]
mov word[num], ax
call htoa

; new line
write nl, nl_len


; Step 6: Display the CPUID
; It is made up of 12 bytes -> 4 + 4 + 4 -> distributed in ebx:edx:ecx

write cpuidContentsMessage, cpuidContentsMessageLen
xor eax, eax
CPUID
mov dword[cpuid_contents], ebx
mov dword[cpuid_contents+4], edx
mov dword[cpuid_contents+8], ecx
write cpuid_contents, 12

; new line
write nl, nl_len


endsyscall

htoa:
mov ax, word[num]
mov byte[count], 04
mov rbp, numarr
loop1:
rol ax, 04
mov bl, al
and bl, 0Fh
cmp bl, 09h
jle next1
add bl, 07h
next1:
add bl, 30h
mov [rbp], bl
inc rbp
dec byte[count]
jnz loop1
write numarr, 04
ret
