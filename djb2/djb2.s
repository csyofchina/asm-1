# djb2 hash
.include "/home/graham/asm/lib/Mstd.s"

.data

	start: .asciz "Start"
	startlen = . - start

.bss

.text

.global _start

_start:

	mov $start, %rbx
	mov $0, %rcx
	mov $5381, %rax				# hash = 5381. rax is 'hash', 8 bytes

hashtop:
	movb (%rbx, %rcx), %dl		# c = *str. dl is 'c'
	cmp $0, %dl					# Have we reached end of string?
	je End

	mov %rax, %r8
	shl $5, %r8		# hash << 5
	add %r8, %rax	# hash = (hash << 5) + hash
	add %rdx, %rax	# + c

	inc %rcx
	jmp hashtop

End:
	# Result to print is already in %rax
	mov $4, %rcx	# Only want the lower 4 bytes
	call WriteHex	# from lib/std.s

	Exit			# Macro in Mstd.s
