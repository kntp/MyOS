TARGET     = goc
STACKSIZE  =
MALLOCSIZE =
MMAREA     =
OBJS       = abs.o atof.o atoi.o errno.o frexp.o ldexp.o \
	memchr.o memcmp.o memmove.o memset.o qsort.o rand.o \
	sprintf.o strcat.o strcmp.o strcpy.o strcspn.o strdup.o \
	strlen.o strncat.o strncmp.o strncpy.o strpbrk.o strrchr.o \
	strspn.o strstr.o strtol.o strtoul.o strtoul0.o vsprintf.o
 
# 以上5つはソースごとに書き換える
# OBJSを書き換えると分割コンパイル対応
 
TOOLPATH =
INCPATH  = .
MAKE     = $(TOOLPATH)make -r
CC      = gcc
GOLIB    = ar
DELE     = rm -rf

CFLAGS = -nostdlib

# 以上の項目はあなたのディレクトリ構成にあわせて書き換える

	
lib$(TARGET).a : $(OBJS) Makefile
	$(GOLIB) -rv $@ $(OBJS)

clean :
	$(DELE) *.o
	$(DELE) lib$(TARGET).a

c.o:
	$(CC) $< $(CFLAGS) -c -o $@
