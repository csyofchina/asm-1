.include "/home/graham/asm/lib/Mstd.s"

.data
	.set pageSize, 4096	# Ask kernel for this many bytes at once
	.set answer, 42		# Fill the memory with truth

	failStr: .ascii "Fail\n"
	failStrLen = . - failStr

.text

.global _start

_start:
	call testAlloc
	call testAllocPage
	Exit

testAlloc:

	# Allocate some memory, and put stuff in it

	# Byte
	mov $1, %ax
	call Alloc
	movb $0x0A, (%rsi)

	# Word
	mov $2, %ax
	call Alloc
	movw $0x00BB, (%rsi)

	# Double
	mov $4, %ax
	call Alloc
	movl $0x0000CCCC, (%rsi)

	# Quad
	mov $8, %ax
	call Alloc
	movq $0xDDDDDD, (%rsi)

	# In gdb do: x/16xb pageAddr

	# Try to allocate too much
	movw $8000, %ax
	call Alloc
	cmp $0, %rsi	# %rsi should be 0, meaning error
	jne fail

	# Now display the results

	xor %rax, %rax
	mov pageAddr, %rsi
	movb (%rsi), %al
	mov $1, %rcx
	call WriteHex
	add %rcx, %rsi	# Move to next value

	movw (%rsi), %ax
	mov $2, %rcx
	call WriteHex
	add %rcx, %rsi

	movl (%rsi), %eax
	mov $4, %rcx
	call WriteHex
	add %rcx, %rsi

	movq (%rsi), %rax
	mov $8, %rcx
	call WriteHex

	# Force a new page, by asking for pageSize-1 bytes
	mov pageAddr, %r10
	xor %rax, %rax
	mov $pageSize, %ax
	dec %ax
	call Alloc
	cmp pageAddr, %r10	# pageAddr should have changed
	je fail

	ret

# Display error and quit
fail:
	Write $failStr, $failStrLen
	Exit

testAllocPage:

	call AllocPage

	# We should now be able to write 4k of whatever we want
	# between %rsi and %rsi+pageStart

	# So let's fill it with 42, see if it seg faults

	xor %rax, %rax			# Set rax to 0
	movb $answer, %al		# al is the value we're going to write to memory
	mov $pageSize, %rcx			# Repeat pageSize times
	mov %rsi, %rdi			# starting from address %rsi
	rep stosb				# Copy byte %al to %rsi++ %rcx times

	mov $99, %al

	# Now move them one by one into %al so we can see them in gdb
	xor %rdx, %rdx
	mov %rsi, %rbx
display:
	lea (%rbx,%rdx), %r10
	movb (%rbx,%rdx), %al
	inc %rdx
	cmp $pageSize, %rdx
	jne display

	ret
