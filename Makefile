os.img: ipl.bin os.sys
	mformat -f 1440 -C -B ipl.bin -i os.img ::
	mcopy os.sys -i os.img ::

ipl.bin: ipl.o lnk.ls
	ld -nostdlib -o ipl.bin ipl.o -Tlnk.ls
	
ipl.o: ipl.s
	as -o ipl.o ipl.s

head.bin: head.o head.ls
	ld -nostdlib -o head.bin head.o -Thead.ls

head.o: head.s
	as -o head.o head.s

func.o: func.s func.h
	as -o func.o func.s

bootpack.o: bootpack.c func.h
	gcc bootpack.c -nostdlib -Wl,--oformat=binary -c -o bootpack.o

boot.bin: func.o bootpack.o
	ld -o boot.bin -e Main --oformat=binary bootpack.o func.o

os.sys: head.bin boot.bin
	cat head.bin boot.bin > os.sys

.PHONY: run
run:
	qemu -m 32 -localtime -vga std -boot a -fda os.img

.PHONY: debug
debug:
	qemu -s -S -m 32 -localtime -vga std -boot a -fda os.img -redir tcp:5555:127.0.0.1:1234 &

.PHONY: clean
clean:
	rm -f *~
	rm -f *.bin
	rm -f os.sys
	rm -f os.img
	rm -f *.o
	rm -f a.out
