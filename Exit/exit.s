.section .data
   coinsList: .long 25,2,5,10,50,0

.section .text

.globl _start
_start:
    movl $0, %edi
    movl coinsList(,%edi,4), %eax
    movl %eax, %ebx

loopStart:
    cmp $0, %ebx
    jg loopEnd2

loopEnd1:
    mov $1, %eax
    mov $11, %ebx
    int $0x80

loopEnd2:
    mov $1, %eax
    mov $22, %ebx
    int $0x80
