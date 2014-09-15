.include "/home/graham/asm/lib/Mstd.s"

.data

	head: .quad 0
	tail: .quad 0

.bss

	# Static the nodes, so we don't have to alloc memory yet
	.lcomm node1, 9	# 8 bytes for 'next', 1 byte for 'val'
	.lcomm node2, 9
	.lcomm node3, 9

.text

.global _start

_start:

	# Create the nodes
	mov $node1, %rdi
	movq $0, (%rdi)
	movb $12, 8(%rdi)
	mov $node2, %rdi
	movq $0, (%rdi)
	movb $24, 8(%rdi)
	mov $node3, %rdi
	movq $0, (%rdi)
	movb $42, 8(%rdi)

	# Add node 1
	mov $node1, %rdi
	mov %rdi, head
	mov %rdi, tail

	mov head, %rsi
	call walk

	# Add node 2
	mov $node2, %rsi
	mov tail, %rdi
	mov %rsi, (%rdi)
	mov %rsi, tail

	mov head, %rsi
	call walk

	# Add node 3
	mov $node3, %rsi
	mov tail, %rdi
	mov %rsi, (%rdi)
	mov %rsi, tail

	mov head, %rsi
	call walk

	Exit

# Input: head in %rsi
walk:
	push %rax
	push %rbx
	push %rcx
	push %rdi

	xor %rcx, %rcx

.LwalkLoop:
	mov $1, %rcx
	mov 8(%rsi), %rax
	call WriteHex

	mov (%rsi), %rsi
	cmp $0, %rsi
	jne .LwalkLoop

	pop %rdi
	pop %rcx
	pop %rbx
	pop %rax
	ret
