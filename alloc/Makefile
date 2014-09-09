all: alloc

alloc.o: alloc.s
	as -gstabs+ -o alloc.o alloc.s

alloc: alloc.o
	ld -o alloc alloc.o

clean:
	rm alloc *.o
