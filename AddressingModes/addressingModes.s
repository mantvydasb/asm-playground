SECTION .data
var1:	db "Hello World", 10
len:	equ $-var1

var2:	db "World30pienas", 6
len2:	equ $-var2

var3: db 1,5,0xA,0xB,0xC
var4: db 5,5,5,5

SECTION .text		
global _start		
_start:			

	; point ecx to the start of var1; Will print "Hello World";
	mov	edx, len		
	mov	ecx, var1	
	mov	ebx, 1		
	mov	eax, 4		
	int	0x80		

	; point ecx to the start of var1 and increment the pointer by one byte. Will print "ello World";
	mov	edx, len - 1		
	mov	ecx, var1 + 1
	mov	ebx, 1		
	mov	eax, 4		
	int	0x80		

	; lookup var1 address and put its contents into ecx; This will not print anything as ecx will contain the first four bytes of the "Hello" - 0x48 0x65 0x6c 0x6c;
	mov	edx, len		
	mov	ecx, [var1]
	mov	ebx, 1		
	mov	eax, 4		
	int	0x80		

	; will print out "30" out of the var2;
	mov	edx, 2		
	mov	ecx, var2 + 5	
	mov	ebx, 1		
	mov	eax, 4		
	int	0x80		

	; points to the address of the 1st element of the array;
	mov	eax, var3
	
	; points to the address of the 2nd element of the array;
	mov	eax, var3 + 1
	
	; puts 0x0b0a0501 into eax aka put 4 bytes from the address where var3 starts;
	mov	eax, [var3]

	; puts 0x0c0b0a05 (note the missing 01 byte at the end and notice the 0c in front) into eax aka put 4 bytes from the address where var3 starts;
	mov	eax, [var3 + 1]

	; puts var3 memory location address into eax. Same as mov eax, var3;
	lea	eax, [var3]

	; puts var3 memory location (+1 offset byte) address into eax. Same as mov eax, var3;
	lea	eax, [var3 + 1]

	; puts the 0x00600150 as a value in the eax; This will start pointing to "o World World30Pienas" 
	mov ebx, 0x00600150
	
	; puts 4 bytes found at address 0x00600150, which happen to be 72 6c 64 0a - "rld " (next to the Hello World30Pienas)
	mov ebx, [0x00600150]
	
	push 0x444442

	mov rcx, [rsp + 32]

	; puts a value into eax that seems to be a valid memory location then write DDDD into that address;
	mov eax, 0x00600150
	mov dword [eax], 0x44444444
	
	; puts ASCII EEEE 16 bytes (next-line in the data-dump) further from 0x00600150;
	mov dword [0x00600150 + 16], 0x41414141
	
	; puts VMXh string in that position;
	mov dword [0x00600150], "VMXh"
	
	; these are the same and will both point to the start of string VMXh;
	lea edx, [0x00600150]
	mov ecx, 0x00600150

	; puts value found at rcx + 16 offset bytes into rbx;
	lea rbx, [rcx + 16]
	
	mov eax, 0
	test eax, eax

	mov	ebx, 0		
	mov	eax, 1		
	int	0x80		