.section .data
   coinsList: .long 25,2,5,10,50,0

.section .text

.globl _start
_start:
    mov $2, %edi
    inc %edi
    mov coinsList(,%edi,4), %eax
    mov %eax, %ebx
    mov $1, %eax
    int $0x80

loopStart:
    cmp $0, %ebx
    mov $1, %eax
    mov $12, %ebx

loopEnd:
    mov $1, %eax
    mov $12, %ebx
    int $0x80

; loopStartas:
;     mov $1, %eax
;     jmp loopStartas2
;
; loopStartas2:
;     mov $54, %ebx
;     jmp loopStart
