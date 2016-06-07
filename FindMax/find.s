# PURPOSE
#
# Find the biggest coin in the list. Program stops iterating through the coins list
# when it finds a coin with value 0 at the end of the list.
#
# VARIABLES
# %edi - index of the coin being looked at;
# %eax - current coin value being looked at;
# %ebx - biggest coin value;
# coinsList - list of all coin values;

.section .data
   coinsList: .long 25,40,77,10,99,101,0

.section .text

.globl _start
_start:
    mov $0, %edi
    mov coinsList(,%edi,4), %eax # eax = coinsList[0]
    mov %eax, %ebx

loopStart:
    cmp $0, %eax
    je loopEnd # if eax == 0 then loopEnd:
    inc %edi # edi++
    mov coinsList(,%edi,4), %eax

    cmp %ebx, %eax
    jle loopStart #if eax <= ebx then loopStart
    mov %eax, %ebx
    jmp loopStart

loopEnd:
    mov $1, %eax
    int $0x80
