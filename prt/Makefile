all: prt

prt.o: prt.s
	as -gstabs+ -o prt.o prt.s

prt: prt.o
	ld -o prt ../lib/std.o prt.o

clean:
	rm prt *.o
