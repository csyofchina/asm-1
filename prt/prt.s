.include "/home/graham/asm/lib/Mstd.s"

.data

	t: .int 0x0e1e39b3

.text

.global _start

_start:

	mov (t), %rax
	mov $4, %rcx
	call WriteHex

	Exit
