all: upper

upper.o: upper.s
	as -o upper.o upper.s

upper: upper.o
	gcc -Wall -s -nostdlib -o upper upper.o

test:
	cat upper.s | ./upper
