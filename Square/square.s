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
    #just testing some xor'ing
    mov $4, %eax
    xor %eax, %eax
    mov $4, %eax
    mov $5, %ebx
    xor %eax, %ebx

    push $5
    push $8
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

	push $2
	push $3

    mov %ebp, %esp
    pop %ebp
    ret
