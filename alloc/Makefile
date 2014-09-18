all: alloc

alloc.o: alloc.s
	as -gstabs+ -o alloc.o alloc.s

alloc: alloc.o
	ld -o alloc ../lib/std.o alloc.o

clean:
	rm alloc *.o
