prog : tri.o
	gcc -o prog tri.o

tri.o : tri.c
	gcc -o tri.o -c tri.c
