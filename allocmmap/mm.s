.include "/home/graham/asm/lib/Mstd.s"

.data
	.set pageSize, 4096

.text

.global _start

_start:

	mov $9, %rax		# mmap
	mov $0, %rdi		# addr=NULL
	mov $pageSize, %rsi	# length=pageSize
	mov $3, %rdx		# prot=PROT_READ|PROT_WRITE
	mov $34, %r10		# flags=MAP_PRIVATE|MAP_ANONYMOUS
	mov $-1, %r8		# fd=-1
	mov $0, %r9			# offset=0
	syscall

	# %rax is our address, save it in %rsi
	mov %rax, %rsi

	# Fill the page with 42
	xor %rax, %rax		# Set %rax to 0
	movb $42, %al		# al is byte to write to memory
	mov $pageSize, %rcx	# Repeat this many times
	mov %rsi, %rdi		#  starting from %rdi
	rep stosb

	mov $99, %al

	Exit
