CFLAGS = -g -m32 -nostdlib -Wl,--oformat=binary -I./include
LDLIBS = -L./lib -lgoc

os.img: ipl.bin os.sys
	mformat -f 1440 -C -B ipl.bin -i os.img ::
	mcopy os.sys -i os.img ::

os.sys: head.bin boot.bin
	cat head.bin boot.bin > os.sys

ipl.bin: ipl.o ipl.ls
	ld -melf_i386 -nostdlib -o ipl.bin ipl.o -Tipl.ls -Map=ipl.map
	
head.bin: head.o head.ls
	ld -melf_i386 -nostdlib -o head.bin head.o -Thead.ls -Map=head.map

boot.bin: func.o boot.o startup.o hankaku.o
	ld -melf_i386 -nostdlib -static -o boot.bin -e Main -n -Tos.ls \
	boot.o $(LDLIBS) func.o hankaku.o -Map=boot.map

func.o: func.s

func.s: func.h
boot.c: func.h

.PHONY: run
run: os.img
	qemu -m 32 -localtime -vga std -boot a -fda os.img

.PHONY: debug
debug:
	qemu -s -S -m 32 -localtime -vga std -boot a -fda os.img -redir tcp:5555:127.0.0.1:1234 &

.PHONY: clean
clean:
	rm -f os.sys
	rm -f os.img
	rm -f *~
	rm -f *.bin
	rm -f *.o
	rm -f *.map

# suffix rule
.s.o:
	as -32 -o $@ $<
.c.o:
	gcc $< $(CFLAGS) -c -o $@
