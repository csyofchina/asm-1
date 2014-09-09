.include "/home/graham/asm/lib/Mstd.s"

.data

	#line: .ascii "----\n"
	#.set lineLen, . - line

	lineStart: .word 0
	lineEnd: .word 0

	.set buflen, 32	# Size of input buffer

	isEOF: .byte 0
	bInBuf: .byte 0		# Bytes left to process in buffer

.bss

	.lcomm buf, buflen	# Buffer for reading from stdin

.text

.global _start

_start:
	nop
resetReadStart:
	mov $0, %ebx

readStart:
	#Write $line, $lineLen

	mov $1, %al
	cmpb (isEOF), %al	# Have we hit input EOF?
	je findLineEnd		# Yes, just process rest of buffer

	# Not at EOF yet, read some more into buffer
	mov $0, %rax		# NR_read
	mov $0, %rdi		# Read from stdin
	mov $buf, %rsi		# Read into buf
	add %rbx, %rsi		# After the first time, read into $buf+%ebx
	mov $buflen, %rdx	# Read up to buflen bytes
	sub %rbx, %rdx		# After the first time, the buffer is partly full
	syscall

	cmp $0, %rax
	jne findLineEndA

	movb $1, (isEOF)	# 'read' returned EOF, just need to process rest of buffer
	jmp findLineEnd

findLineEndA:
	movb (bInBuf), %dl
	add %al, %dl
	movb %dl, (bInBuf)

findLineEnd:

	# Is there anything more to process?
	cmpb $0, (bInBuf)
	je End

	# Find the offset of \n in $buf and put it in $lineEnd
	call setLineEnd

	# Write out a line
	mov $buf, %rsi
	xor %rdx, %rdx
	movw (lineEnd), %dx		# Offset of \n now in %rdx
	call Write

	# Adjust remaining by how many bytes we just processed
	mov (bInBuf), %al
	sub %dl, %al
	mov %al, (bInBuf)

	# If we ran out of buffer, there's no remaining part to preserve
	cmp $buflen, %rdx
	je resetReadStart

	# Copy remaining part of buf to start of buf
	mov $buf, %rsi	# Source is buf
	add %rdx, %rsi	# Move source pointer along to found \n
	mov $buf, %rdi	# Destination is also buff
	mov $buflen, %rcx	# Number of bytes to move is buflen - (pos of \n)
	sub %rdx, %rcx
	mov %rcx, %rbx	# Save the number of characters we're copying
	rep movsb

	# We now have %rbx bytes of unprocessed data at $buf

	jmp readStart

End:

	Exit

# ----
# setLineEnd: Find first \n in $buf, and store it's offset at $lineEnd
#
# IN: $buf
# OUT: $lineEnd
#
setLineEnd:
	push %rax
	push %rdi
	push %rcx

	mov $10, %al	# ascii 10 is \n, this is what we scan for
	mov $buf, %rdi	# address to start scan at
	mov $buflen, %rcx	# Don't search past end of buffer. loop uses this

.Lloop:
	scasb
	jz .Lend
	loop .Lloop

.Lend:
	# Now %rdi should point at \n
	sub $buf, %rdi	# addr(\n) - addr(start) is length of string in bytes
	movw %di, (lineEnd)

	pop %rcx
	pop %rdi
	pop %rax
	ret
