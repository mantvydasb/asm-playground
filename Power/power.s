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
    message: .string "2 power of 5 is: "
    rEBP: .string "EBP is: "
    result: .long 0

.section .text

.globl _start
_start:
    pushl $5 #power
    pushl $2 #base
    call power
    addl $8, %esp
    mov %eax, result

#    push $2
#    push $5
#    call power
#    add $8, %esp
#    pop %ebx
#    add %eax, %ebx

    mov $4, %eax
    mov $1, %ebx
    mov $message, %ecx
    mov $17, %edx
    int $0x80

    movl $1, %eax
    mov result, %ebx
    int $0x80


.type power, @function
power:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    movl %ebx, -4(%ebp)

    powerLoopStart:
        cmp $1, %ecx
        je endPower
        movl -4(%ebp), %eax
        imull %ebx, %eax
        movl %eax, -4(%ebp)
        decl %ecx
        jmp powerLoopStart

    endPower:
        movl -4(%ebp), %eax
        movl %ebp, %esp
        popl %ebp
        ret
