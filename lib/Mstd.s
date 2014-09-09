.macro Exit
	mov $60, %eax	# NR_exit
	mov $0, %edi	# exit code 0
	syscall
.endm

.macro Write str strlen
	push %rax
	push %rdi
	push %rsi
	push %rdx

	mov $1, %eax		# NR_write
	mov $1, %edi		# destination is stdout
	mov \str, %esi		# src is \str
	mov \strlen, %edx	# length of str
	syscall

	pop %rdx
	pop %rsi
	pop %rdi
	pop %rax
.endm
