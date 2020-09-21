

%macro fun 4	; Macro to read and write
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro


SECTION .data

extern hex_to_ascii
extern find_substring
extern concatenate_string
extern exit
global llen1
global llen2
global str1
global str2
global str3
msg1 : db 10,"Menu",10,"1. Calculate length",10,"2. Find sub-string",10,"3. Concatenate string",10,"4. Exit",10,"Enter choice : ",0
len1 : equ $-msg1
msg2 : db "Enter a string : ",0
len2 : equ $-msg2
msg3 : db "Length of string is : ",0
len3 : equ $-msg3
msg4 : db "Enter string to find no of occurrence : ",0
len4 : equ $-msg4
msg5 : db "Length of sub-string must b smaller than original string",10
len5 : equ $-msg5
msg6 : db "Occurrence of substring is : ",0
len6 : equ $-msg6
msg7 : db "Concatenated string is : ",0
len7 : equ $-msg7



SECTION .bss

str1 resq 100
str2 resq 100
str3 resq 200
result resq 2
choice resb 2
llen1 resb 10
llen2 resb 10



SECTION .text
global _start
_start:

cont:
	fun 1,1,msg1,len1	; prints menu
	fun 0,0,choice,2

	cmp byte[choice],34h
	je exit1

try:
	fun 1,1,msg2,len2	
	fun 0,0,str1,800	; Accepts str1
	cmp rax,1
je try

	sub rax,1
	mov rbx,rax
	mov r15,rax
	mov rsi,result
	call hex_to_ascii	; Far call

	cmp byte[choice],31h
	je length
	cmp byte[choice],32h
	je sub_string
	cmp byte[choice],33h
	je concat

jmp cont

;---------------LENGTH----------------
length:
	fun 1,1,msg3,len3
	fun 1,1,result,16	; Prints length of a string
jmp cont

;---------------SUB-STRING-------------	
sub_string:
	fun 1,1,msg4,len4
	fun 0,0,str2,800	;read str2
	cmp rax,1
je sub_string

	sub rax,1
	mov r14,rax
	mov qword[llen1],r15
	mov qword[llen2],r14

	xor r8,r8		; Will contain result
	cmp r14,r15
	jg long_length
	call find_substring	; Far call
	mov rbx,r8
	mov rsi,result
	call hex_to_ascii	; Far call
	fun 1,1,msg6,len6
	fun 1,1,result,16
jmp cont

long_length:			; if length(substring)>length(original string)
	fun 1,1,msg5,len5
jmp sub_string

;------------CONCATENATE-------------
concat:

	fun 1,1,msg2,len2
	fun 0,0,str2,800
	cmp rax,1
	je concat
	call concatenate_string	; Far call
	fun 1,1,msg7,len7
	fun 1,1,str3,1600
jmp cont

;-----------EXIT-----------
exit1:
call exit



