all: hello

hello.o: hello.s
	as -gstabs -o hello.o hello.s

hello: hello.o
	ld -o hello hello.o

