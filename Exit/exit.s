.section .data
   coinsList: .byte 1,2,5,10,50,0

.section .text

.globl _start
    _start:
        mov $1, %eax
        mov $4, %edi
        mov coinsList(,%edi,1), %ebx
        int $0x80
