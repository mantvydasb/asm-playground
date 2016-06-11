# PURPOSE
#
# Find the biggest coin from the list.
# Use a function that takes a pointer to several values and returns the biggest out of them.
#
# VARIABLES
# ebx - current element
# ecx - max element

.section .data
   coinsList: .long 25,40,77,80,10,99,255,10,5,7,5,99,101,10,5,7,58,3,0

.section .text

.globl _start
_start:
    push $coinsList
    call findMax
    add $4, %esp

    mov %eax, %ebx
    mov $1, %eax
    int $0x80

.type findMax, @function
findMax:
    push %ebp
    mov %esp, %ebp

    #eax = coinsList
    mov 8(%ebp), %eax
    mov $0, %edi

    #maxElement = eax[0]
    mov 0(%eax), %ecx

    loopStart:
        #ebx = getCurrentElement()
        mov (%eax, %edi, 4), %ebx
        cmp $0, %ebx
        je loopEnd
        inc %edi

        cmp %ecx, %ebx
        jle loopStart

        mov %ebx, %ecx
        jmp loopStart

    loopEnd:
        mov %ecx, %eax
        mov %ebp, %esp
        pop %ebp
        ret
