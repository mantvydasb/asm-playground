# A simple memory manager to allocate and deallocate memory;

.section .data
    heap_begin: .long 0
    current_break: .long 0

    ######STRUCTURE INFORMATION####
    .equ HEADER_SIZE, 8         #size of space for memory region header
    .equ HDR_AVAIL_OFFSET, 0    #Location of the "available" flag in the header
    .equ HDR_SIZE_OFFSET, 4     #Location of the size field in the header


    ###########CONSTANTS###########
    .equ UNAVAILABLE, 0         #This is the number we will use to mark space that has been given out
    .equ AVAILABLE, 1           #This is the number we will use to mark space that has been returned, and is available for giving
    .equ SYS_BRK, 45            #system call number for the break
    .equ SYS_CALL, 0x80    #make system calls easier to read

.section .text
    # function allocate_init: call this function to initialize the functions. Specifically, this sets heap_begin and current_break;

.globl _start
_start:
    call allocate_init

    push $8
    call allocate

.globl allocate_init
.type allocate_init,@function
    allocate_init:
    pushl %ebp          #standard function stuff
    movl %esp, %ebp

    #If the brk system call is called with 0 in %ebx, it returns the last valid usable address
    movl $SYS_BRK, %eax
    movl $0, %ebx
    int $SYS_CALL

    incl %eax #%eax now has the last valid address, and we want the memory location after that
    movl %eax, current_break #store the current break
    movl %eax, heap_begin #store the current break as our
    movl %ebp, %esp
    popl %ebp
    ret


    # function allocate: This function is used to grab a section of memory. It checks to see if there are any
    # free blocks, and, if not, it asks Linux for a new one'
    # %ecx - hold the size of the requested memory first/only parameter)
    # eax - current memory region being examined
    # ebx - current break position
    # edx - size of current memory region

.globl allocate
.type allocate,@function
    .equ ST_MEM_SIZE, 8 #stack position of the memory size

    allocate:
        pushl %ebp
        movl %esp, %ebp
        movl ST_MEM_SIZE(%ebp), %ecx
        movl heap_begin, %eax
        movl current_break, %ebx

    alloc_loop_begin:
        cmpl %ebx, %eax
        je move_break
        movl HDR_SIZE_OFFSET(%eax), %edx

        cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        je next_location

        cmpl %edx, %ecx
        jle allocate_here


    next_location:
        addl $HEADER_SIZE, %eax
        addl %edx, %eax
        jmp alloc_loop_begin

    allocate_here:
        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        addl $HEADER_SIZE, %eax
        movl %ebp, %esp
        popl %ebp
        ret

    move_break:
        addl $HEADER_SIZE, %ebx #add space for the headers
        addl %ecx, %ebx
        pushl %eax
        pushl %ecx
        pushl %ebx
        movl $SYS_BRK, %eax #reset the break
        int $SYS_CALL

        cmpl $0, %eax
        je error #check for error conditions
        popl %ebx
        popl %ecx
        popl %eax

        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        movl %ecx, HDR_SIZE_OFFSET(%eax)
        addl $HEADER_SIZE, %eax
        movl %ebx, current_break #save the new break
        movl %ebp, %esp
        popl %ebp
        ret

    error:
        movl $0, %eax
        movl %ebp, %esp
        popl %ebp
        ret

.globl deallocate
.type deallocate,@function
    .equ ST_MEMORY_SEG, 4
    deallocate:
    movl ST_MEMORY_SEG(%esp), %eax
    subl $HEADER_SIZE, %eax
    movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
    ret
