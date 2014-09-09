
#include <stdio.h>

int hash() //unsigned char *str)
{
	unsigned char *str = "Start";
    unsigned long hash = 5381;
    int c;

	printf("Before %lu, 0x%lx\n", hash, hash);
    while (c = *str++)	{
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
		printf("%c, %lu, 0x%lx\n", c, hash, hash);
	}

    return hash;
}

int main(int argc, char *argv[]) {
	int h = hash();
	printf("Start -> %d, 0x%x\n", h, h);
}
