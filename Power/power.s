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
# -4(%ebp) - current result

.section .data
    message: .string "2 power of 5 is: "
    rEBP: .string "EBP is: "
    result: .long 0

.section .text

.globl _start
_start:
    push $5 #power
    push $2 #base
    call power
    add $20, %esp
    mov %eax, result

    #print message
    mov $4, %eax
    mov $1, %ebx
    mov $message, %ecx

    mov $17, %edx
    int $0x80

    #exit with results
    mov $1, %eax
    mov result, %ebx
    int $0x80


.type power, @function
power:
    push %ebp
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
        pop %ebp
        ret
