# PURPOSE
#
# Calculate the square of a given value;
#
# INPUT
# Value to be squared;

.section .data
.section .text
.globl _start
_start:
    push $10
    call square
    add $4, %esp

    mov %eax, %ebx
    mov $1, %eax
    int $0x80

.type square, @function
square:
    push %ebp
    mov %esp, %ebp
    sub $4, %esp

    mov 8(%ebp), %eax
    imul %eax, %eax

    mov %ebp, %esp
    pop %ebp
    ret
