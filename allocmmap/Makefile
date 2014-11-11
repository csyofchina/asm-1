all: mm

mm.o: mm.s
	as -gstabs+ -o mm.o mm.s

mm: mm.o
	ld -o mm mm.o
