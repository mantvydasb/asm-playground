.section .data
   coinsList: .long 25,2,5,10,50,0

.section .text

.globl _start
_start:
    movl $0, %edi
    movl coinsList(,%edi,4), %eax
    movl %eax, %ebx


loopStartas:
    mov $1, %eax
    jmp loopStartas2

loopStartas2:
    mov $54, %ebx
    jmp loopStart

loopStart:
    cmp $0, %ebx
    mov $1, %eax
    mov $12, %ebx

loopEnd:
    mov $1, %eax
    mov $12, %ebx
    int $0x80
