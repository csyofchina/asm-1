.include "/home/graham/asm/lib/Mstd.s"

.data
	.set pageSize, 4096	# PAGESIZE. We'll allocate this many bytes
	.set answer, 42		# Fill the memory with truth

.text

.global _start

_start:

	call allocate

	# We should now be able to write 4k of whatever we want
	# between %rsi and %rsi+pageStart

	# So let's fill it with 42, see if it seg faults

	xor %rax, %rax			# Set rax to 0
	movb $answer, %al		# al is the value we're going to write to memory
	mov $4096, %rcx			# Repeat pageSize times
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
	cmp $4096, %rdx
	jne display

	Exit

# ---
# Allocate one page of memory
# OUT: %rsi is pointer to allocated memory
allocate:
	push %rax
	push %rdi

	mov $12, %rax	# brk
	# 0 is invalid value. On failure brk returns position of current brk,
	# i.e. the start of the heap, and of the block we're about to allocate
	mov $0, %rdi
	syscall

	mov %rax, %rsi		# Pointer to allocated memory

	mov %rax, %rdi		# Move top of heap to here...
	add $pageSize, %rdi	# .. plus the size of one page
	mov $12, %rax		# Call brk again, this time with valid value
	syscall

	pop %rdi
	pop %rax
	ret
