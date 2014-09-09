.data

.equ CR, 10

.bss

	.lcomm buf, 256
	.equ buflen, 0x00FF

.text
.globl _start

_start:

	read:
	call readmore

	# check for EOF
	cmp $0, %rcx
	je exit

	call convert

	call write

	jmp read	# Start again, read next bytes

	exit:
	mov $60, %eax	# NR_exit
	mov $0, %edi	# exit code 0
	syscall

# Functions

#
# Read stdin into 'buf', putting number bytes read into %rcx
#
readmore:
	mov $0, %eax	# NR_read
	mov $0, %edi	# stdin
	mov $buf, %esi	# &buf
	mov $buflen, %edx	# len(buf)
	syscall
	mov %rax, %rcx	# Save retval in rcx, this is number of bytes read, or EOF
	ret

#
# convert contents of 'buf' to upper case
#
convert:
	mov $0, %edi	# %edi is our index in 'buf' array
convert_loop:
	mov buf(%edi), %al		# The character we're looking at

	# Check it's in a-z
	cmp $'a', %al
	jb convert_skip
	cmp $'z', %al
	ja convert_skip

	sub $0x20, %al	# Convert to upper case by subtracting hex 20 from ascii val
	mov %al, buf(%edi)	# Update changed character in memory

convert_skip:
	inc %edi
	cmp %ecx, %edi
	jne convert_loop
	ret

#
# write 'buf' to stdout
#
write:
	mov $1, %eax		# NR_write
	mov $1, %edi		# stdout
	mov $buf, %esi		# &buf
	mov %ecx, %edx		# len(buf)
	syscall
	ret
