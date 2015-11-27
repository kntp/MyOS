os.img: ipl.bin head.bin
	mformat -f 1440 -C -B ipl.bin -i os.img ::
	mcopy head.bin -i os.img ::

ipl.bin: ipl.o lnk.ls
	ld -nostdlib -o ipl.bin ipl.o -Tlnk.ls
	
ipl.o: ipl.s
	as -o ipl.o ipl.s

head.bin: head.o head.ls
	ld -nostdlib -o head.bin head.o -Thead.ls

head.o: head.s
	as -o head.o head.s

.PHONY: run
run:
	qemu -m 32 -localtime -vga std -boot a -fda os.img

.PHONY: clean
clean:
	rm -f *~
	rm -f *.bin
	rm -f harios.sys
	rm -f os.img
	rm -f *.o
	rm -f a.out
