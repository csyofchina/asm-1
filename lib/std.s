.data
	conv: .ascii "0123456789abcdef0x\n"		# WriteHex

	.set pageSize, 4096	# Alloc, AllocPage
	pageAddr: .quad 0	# Alloc
	pageIdx: .word 0	# Alloc

.global pageAddr	# So that 'asm/alloc' can test it

.bss
	.lcomm convb, 2	# WriteHex

.text

# ----
# Write: Write a string to stdout
# IN:
#  - %rsi: Pointer to string to write
#  - %rdx: Lenth of string
# OUT:
#  - %rax: write' return code
#
.global Write
Write:
	push %rcx
	push %rdi
	mov $1, %rax		# NR_write
	mov $1, %rdi		# destination is stdout
	syscall
	pop %rdi
	pop %rcx
	ret

#----------
# WRITE HEX: Write a number in hex to stdout
# NEED:
#  - In .data:
#	conv: .ascii "0123456789abcdef0x\n"
#  - In .bss:
#	.lcomm convb, 2
# IN:
#  - %rax: Number to write
#  - %rcx: Size of number in bytes (1,2,4,8)
#
# This works by shifting the byte to be converted into %al.
# eg: if param rax = 0x0e1e39b3:
#	First loop shifts to 0x0e	(0e converted and printed)
#	Second loop restores, shifts to 0x0e1e	(1e converted and printed)
#	Third loop restores, shifts to 0x0e1e39 (39 converted and printed)
#	etc
#
.global WriteHex
WriteHex:
	push %rax
	push %rbx
	push %rcx
	push %rdx
	push %rsi
	push %rdi

	# Save %rax, Write uses it
	mov %rax, %r8

	# Print "0x"
	mov $conv, %rsi
	add $16, %rsi	# Point at "0x"
	mov $2, %rdx
	call Write

	# Setup
	xor %rbx, %rbx

.LWHloop:
	mov %r8, %rax

	push %rcx
	dec %rcx
	shl $3, %rcx	# Multiply by 2^3, which is 8
	shr %cl, %rax	# Little-endian, so shift next byte into lower 8 bits
	pop %rcx

	# Load byte into %bl
	movb %al, %bl

	# Map high nibble
	shr $4, %bl
	mov $conv, %rsi
	add %rbx, %rsi

	# Store it in first byte of convb
	movb (%rsi), %bl
	movb %bl, (convb)

	# Map low nibble
	movb %al, %bl
	and $0x0F, %bl
	mov $conv, %rsi
	add %rbx, %rsi

	# Store it in convb second byte
	movb (%rsi), %bl
	mov $1, %rdx
	movb %bl, convb(,%rdx)

	# Display the byte
	mov $convb, %rsi
	mov $2, %rdx
	call Write

	loop .LWHloop

	# Print final \n
	mov $conv, %rsi
	add $18, %rsi
	mov $1, %rdx
	call Write

	pop %rdi
	pop %rsi
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rax
	ret

# ---
# Allocate %ax bytes of memory
# IN: %ax How many bytes to allocate
# OUT: %rsi pointer to allocated memory.
# Don't write past (%rsi + %rax), there's no checks.
.global Alloc
Alloc:
	push %rdx
	push %rdi

	# Cannot allocate more than pageSize bytes
	cmp $pageSize, %rax
	jle .LwithinPageSize
	mov $0, %rsi
	jmp .LallocEnd

.LwithinPageSize:

	# Will requested memory fit in current page?

	movw pageIdx, %dx
	addw %ax, %dx
	cmp $pageSize, %dx
	jle .LnotBeyondPage

	# ... it won't, force new page allocation
	movq $0, pageAddr
	movw $0, pageIdx

.LnotBeyondPage:

	# Do we need to allocate a page?

	mov pageAddr, %rdi
	cmpq $0, %rdi
	jne .LgotPage

	call AllocPage
	mov %rsi, pageAddr	# Store page address at $pageAddr

.LgotPage:

	# rsi = $pageAddr + $pageIdx
	mov pageAddr, %rsi
	addw pageIdx, %rsi

	addw %ax, pageIdx		# Move pageIdx along to next free space

.LallocEnd:
	pop %rdi
	pop %rdx
	ret

# ---
# Allocate one page of memory
# OUT: %rsi pointer to allocated memory
.global AllocPage
AllocPage:
	push %rax
	push %rbx
	push %rcx
	push %rdx
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
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rax
	ret
