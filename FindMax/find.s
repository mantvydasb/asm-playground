.section .data
   coinsList: .long 25,2,77,10,99,0

.section .text

.globl _start
_start:
    mov $0, %edi
    mov coinsList(,%edi,4), %eax ; eax = coinsList[0]
    mov %eax, %ebx

loopStart:
    cmp $0, %eax
    je loopEnd ; if eax == 0 then loopEnd()
    inc %edi ; edi++
    mov coinsList(,%edi,4), %eax
    cmp %ebx, %eax
    jle loopStart
    mov %eax, %ebx
    jmp loopStart

loopEnd:
    mov $1, %eax
    int $0x80
