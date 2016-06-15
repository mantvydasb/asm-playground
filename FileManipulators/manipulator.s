# PURPOSE
#
# Read file A and convert its contents to uppercase, then store the results in the file B.

.section .data

    .equ EOF,       0
    .equ ARG_COUNT, 2
    fileIn: .string "/mnt/HDD1.2/Dev/Asm/FileManipulators/low"
    fileOut: .string "/mnt/HDD1.2/Dev/Asm/FileManipulators/upp"
    errorMessage: .string "Could not open the file.."

    #system calls
    .equ SYS_OPEN,  5
    .equ SYS_WRITE, 4
    .equ SYS_READ,  3
    .equ SYS_CLOSE, 6
    .equ SYS_EXIT,  1
    .equ SYSTEM_CALL,   0x80

    #file open options
    .equ O_READ_ONLY, 0
    .equ O_CREATE_WRONGLY_TRUNC, 03101

    #file descriptors
    .equ STDIN,     0
    .equ STDOUT,    1
    .equ STDERR,    2

.section .bss
    .equ BUFFER_SIZE,   20
    .lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

    #stack positions
    .equ ST_RESERVED_BYTES, 8
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8
    .equ ST_ARGC, 0 # number of arguments
    .equ ST_ARGV_0, 4 # program names
    .equ ST_ARGV_1, 8 #input file name
    .equ ST_ARGV_2, 12 #output file name

.globl _start
_start:
    mov %esp, %ebp
    sub $ST_RESERVED_BYTES, %esp

    open_fd_in:
        mov $SYS_OPEN, %eax
        mov $fileIn, %ebx
        #mov ST_ARGV_1(%ebp), %ebx
        mov $O_READ_ONLY, %ecx #does not matter for reading files, but oh well
        mov $0666, %edx
        int $SYSTEM_CALL

        #check if file openede successfully
        cmp $0, %eax
        jl fileError

    store_fd_in:
        mov %eax, ST_FD_IN(%ebp)

    open_fd_out:
        mov $SYS_OPEN, %eax
        mov $fileOut, %ebx
        #mov ST_ARGV_2(%ebp), %ebx
        mov $O_CREATE_WRONGLY_TRUNC, %ecx
        mov $0666, %edx
        int $SYSTEM_CALL

        cmp $0, %eax
        jl fileError

    store_fd_out:
        mov %eax, ST_FD_OUT(%ebp)

    read_loop_begin:
        #read in a block from the input file
        mov $SYS_READ, %eax
        mov ST_FD_IN(%ebp), %ebx
        mov $BUFFER_DATA, %ecx
        mov $BUFFER_SIZE, %edx
        int $SYSTEM_CALL

        #exit if EOF
        cmp $EOF, %eax
        jle end_loop

    continue_read_loop:
        #transform the block to uppercase
        push $BUFFER_DATA
        push %eax #number of bytes read from the input file
        call transform_text_touppercase
        pop %eax
        add $4, %esp

        #write the transformed block to the output file
        mov %eax, %edx #edx = BUFFER_SIZE
        mov $SYS_WRITE, %eax
        mov ST_FD_OUT(%ebp), %ebx
        mov $BUFFER_DATA, %ecx
        int $SYSTEM_CALL
        jmp read_loop_begin

    end_loop:
        mov $SYS_CLOSE, %eax
        mov ST_FD_OUT(%ebp), %ebx
        int $SYSTEM_CALL

        mov $SYS_CLOSE, %eax
        mov ST_FD_IN(%ebp), %ebx
        int $SYSTEM_CALL

        mov $SYS_EXIT, %eax
        mov $0, %ebx
        int $SYSTEM_CALL


    fileError:
        mov $SYS_WRITE, %eax
        mov $1, %ebx
        mov $errorMessage, %ecx
        int $SYSTEM_CALL

        mov $SYS_EXIT, %eax
        mov $0, %ebx
        int $SYSTEM_CALL


.type transform_text_touppercase, @function
transform_text_touppercase:
    # INPUT
    # First parametere is the location of the block of memory to convert
    # Second - length of that buffer.
    #
    # VARIABLES
    # eax - beginning of a buffer
    # ebx - buffer length
    # edi - current buffer offset
    # cl - current byte being examined (first part of ecx)

    # CONSTANTS
    .equ LOWERCASE_A, 'a'
    .equ LOWERCASE_Z, 'z'
    .equ UPPER_CONVERSION, 'A' - 'a'

    # Length of buffer
    .equ ST_BUFFER_LEN, 8

    # Actual buffer
    .equ ST_BUFFER, 12

    transform_to_upper:
        push %ebp
        mov %esp, %ebp

        # set up variables
        mov ST_BUFFER(%ebp), %eax
        mov ST_BUFFER_LEN(%ebp), %ebx
        mov $0, %edi

        # leave if bufferLength < 0 was given to us
        cmp $0, %ebx
        je convert_loop_end

    convert_loop:
        # get first byte of the buffer - buffer[0]
        mov (%eax, %edi, 1), %cl
        cmp $LOWERCASE_A, %cl #may need cmpb
        jl next_byte
        cmp $LOWERCASE_Z, %cl
        jg next_byte

        add $UPPER_CONVERSION, %cl
        mov %cl, (%eax, %edi, 1)

    next_byte:
        inc %edi
        cmp %edi, %ebx
        jne convert_loop

    convert_loop_end:
        mov %ebp, %esp
        pop %ebp
        ret
