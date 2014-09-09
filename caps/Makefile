all: caps

caps.o: caps.s
	as -o caps.o caps.s

caps: caps.o
	ld -o caps caps.o

