all: ll

ll.o: ll.s
	as -gstabs+ -o ll.o ll.s

ll: ll.o
	ld -o ll ../lib/std.o ll.o

clean:
	rm ll *.o
