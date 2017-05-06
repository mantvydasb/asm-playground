section .data
string db 'mantukelis world'
len equ $-string
char db 's', 0

foundString db 'found!', 0xa
lenfoundString equ $-foundString

notfoundString db 'not found!'
lenNotfoundString equ $-notfoundString   

section .text
   global _start
	
_start:	                
   mov rcx, len
   mov edi, string
   mov eax, [char]
   cld
   repne scasb
   je found ; at this point, ecx = string.length - position of where in the string the eax was found.
	
   mov eax, 4
   mov ebx, 1
   mov ecx, notfoundString
   mov edx, lenNotfoundString
   int 80h
   jmp exit
	
found:
   mov eax, 4
   mov ebx, 1
   lea ecx, [edi - 2] ; this will print the string searched. Starting with one symbol back from where the searched character was found. I.e if the string was "mantas" and we searched for "n", this prints "antas".
   mov edx, lenfoundString
   int 80h
	
exit:
   mov eax, 1
   mov ebx, 0
   int 80h
	
