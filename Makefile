os.img: ipl.bin
	mformat -f 1440 -C -B ipl.bin -i os.img

ipl.bin: ipl.o lnk.ls
	ld -nostdlib -o ipl.bin ipl.o -Tlnk.ls
	
ipl.o: ipl.s
	as -o ipl.o ipl.s

.PHONY: run
run:
	qemu -m 32 -localtime -vga std -fda os.img

.PHONY: clean
clean:
	rm -f *~
	rm -f ipl.bin
	rm -f harios.sys
	rm -f os.img
	rm -f *.o
	rm -f a.out
