all: djb2

djb2.o: djb2.s
	as -gstabs+ -o djb2.o djb2.s

djb2: djb2.o
	ld -o djb2 ../lib/std.o djb2.o

clean:
	rm djb2 *.o
