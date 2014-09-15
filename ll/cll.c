#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node {
	struct node *next;
	int val;
};

void walk(struct node *head) {
	if (head == NULL) {
		printf("\n");
		return;
	}

	struct node *n = head;
	while (n != NULL) {
		printf("%d\n", n->val);
		n = n->next;
	}
}

void add(struct node **tail, struct node *n) {
	if ((*tail) == NULL) {	// First node
		*tail = n;
		return;
	}
	(*tail)->next = n;
	*tail = n;
}

int main(int argc, char *argv[]) {
	struct node *head, *tail, *node1, *node2, *node3;
	head = 0;
	tail = 0;

	// Create the nodes
	node1 = malloc(sizeof(struct node));
	node1->val = 12;
	node2 = malloc(sizeof(struct node));
	node2->val = 24;
	node3 = malloc(sizeof(struct node));
	node3->val = 42;
	walk(head);

	printf("Add node 1\n");
	head = node1;
	add(&tail, node1);
	walk(head);

	printf("Add node 2\n");
	add(&tail, node2);
	walk(head);

	printf("Add node 3\n");
	add(&tail, node3);
	walk(head);
	return 0;
}
