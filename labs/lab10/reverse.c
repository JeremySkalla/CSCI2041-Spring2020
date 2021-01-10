/* Copyright (c) Gopalan Nadathur */

# include <stdio.h>
# include <stdlib.h>

typedef struct listcell *intlist;
struct listcell { int hd; intlist tl; };

intlist reverse(intlist l, intlist acc) {
  intlist nextl;
  if (l==NULL) return acc;
  else { nextl = l->tl; l->tl = acc; reverse(nextl,l); }
}

void printlist_aux(intlist l) {
  if (l == NULL) return;
  else {
    printf(", %d", l->hd);
    printlist_aux(l->tl);
  }
}

void printlist(intlist l) {
  printf("[");
  if (l != NULL)
    { printf("%d",l->hd);
      printlist_aux(l->tl);
    }
  printf("]");
}

void main () {
  intlist l, templ;
  l = templ = (intlist)malloc(sizeof(intlist *));
  templ->hd = 1;
  templ = templ->tl = (intlist)malloc(sizeof(intlist *));
  templ->hd = 2;
  templ = templ->tl = malloc(sizeof(intlist *));;
  templ->hd = 3;
  templ->tl = NULL;

  printf("The starting list: ");
  printlist(l);
  printf("\n");

  printf("The reversed list: ");
  printlist(reverse(l,NULL));
  printf("\n");
}
