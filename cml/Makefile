all: cml

cml.o: cml.s
	as -gstabs+ -o cml.o cml.s

cml: cml.o
	ld -o cml ../lib/std.o cml.o

clean:
	rm cml *.o

test:
	cat testdata | ./cml
