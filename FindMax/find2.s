# PURPOSE
#
# Find the biggest coin from the list. Program finishes after checking the item at position
# defined in the listLength variable
#
# VARIABLES
# %edi - index of the coin being looked at;
# %eax - current coin value being looked at;
# coinsList - list of all coin values;

.section .data
   coinsList: .long 25,40,77,80,10,99,101,0
   listLength: .long 3
   message: .string "Biggest coin value is: "
   maxCoinValue: .long 0

.section .text

.globl _start
_start:
    mov $0, %edi
    mov coinsList(,%edi,4), %eax # eax = coinsList[0]
    mov %eax, maxCoinValue

loopStart:
    cmp listLength, %edi
    je loopEnd # if edi == listLength then loopEnd:
    inc %edi # edi++
    mov coinsList(,%edi,4), %eax

    cmp maxCoinValue, %eax
    jle loopStart #if eax <= maxCoinValue then loopStart
    mov %eax, maxCoinValue
    jmp loopStart

loopEnd:
    mov $4, %eax
    mov $1, %ebx
    mov $message, %ecx
    mov $24, %edx
    int $0x80

    mov $1, %eax
    mov maxCoinValue, %ebx
    int $0x80
