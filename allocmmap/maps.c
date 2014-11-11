#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>

typedef unsigned char byte;
#define SIZE 4096

int main(int argc, char **argv) {
	printf("Hello mmap\n");

	// mmap is syscall 9 in amd64
	byte *mem = mmap(
		NULL,
		SIZE,
		PROT_READ|PROT_WRITE,	// 3 (1 | 2)
		MAP_PRIVATE|MAP_ANONYMOUS, // 34 (2 | 32)
		-1,
		0);
	if (mem == (byte *) -1) {
		perror("mmap error");
		exit(-1);
	}
	printf("%p\n", mem);
	for (int i = 0; i<SIZE; i++) {
		mem[i] = (byte)i;
	}
	for (int i = 0; i<SIZE; i++) {
		printf("%d %hhu, ", i, mem[i]);
	}
	munmap(mem, SIZE);

	return 0;
}
