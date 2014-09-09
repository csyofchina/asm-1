.data

msg:
	.ascii "Hello, World!\n"
	msglen = . - msg

.text

.global _start

_start:
	mov $1, %eax		# syscall 1 is Write
	mov $1, %edi		# Write to fd 1, stdout
	mov $msg, %rsi		# Message address is in $msg
	mov $msglen, %edx	# Message length is $msglen
	syscall

	mov $60, %eax		# syscall 60 is Exit
	mov $0, %edi		# exit code 0
	syscall
