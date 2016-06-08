# PURPOSE
#
# Calculate the power of a given value;
#
# INPUT
# First argument - base number
# Second argument - power to raise the base to
#
# VARIABLES
# ebx - base
# ecx - power
#-4(%ebp) - current result

.section .data

.section .text

.globl _start
_start:
    push $3
    push $2
    call power
    add $8, %esp
    push %eax

    push $2
    push $5
    call power
    add $8, %esp
    pop ebx

    add %eax, %ebx

    mov $1, %eax
    int $0x80

.type power, @function
power:
    push ebp
    mov %esp, %ebp
    sub $4, %esp

    mov 8(%ebp), %ebx
    mov 12(%ebp), %ecx

    mov %ebx, -4(%ebp)

powerLoopStart:
    cmp $1, %ecx
    je endPower
    mov -4(%ebp), %eax
    imul %ebx, %eax
    mov %eax, -4(%ebp)
    dec %ecx
    jmp powerLoopStart

endPower:
    mov -4(%ebp), %eax
    mov %ebp, %esp
    pop ebp
    ret
