.data

animal:
	.ascii "GIRAFFE\n"
	alen = . - animal

.text

.global _start

_start:

	# Print it before
	mov $1, %ax		# write
	mov $1, %di		# stdout
	movq $animal, %rsi	# string to write
	mov $alen, %dx		# string length
	syscall

	# Lower case it
	mov $0, %ecx		# loop counter, array index
Loop:
	mov animal(%ecx), %ax	# Next character
	add $32, %ax			# 'A' + 32 == 'a'
	mov %ax, animal(%ecx)
	inc %ecx
	cmp $7, %ecx			# len('GIRAFFE') == 7
	jne Loop				# jne is Jump (if) Not Equal

	# Print it after
	mov $1, %ax		# write
	mov $1, %di		# stdout
	movq $animal, %rsi	# string to write
	mov $alen, %dx		# string length
	syscall

	# exit(0)
	mov $60, %ax	# exit
	mov $0, %di
	syscall
