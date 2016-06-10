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
