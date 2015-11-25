os.img: ipl.o lnk.ls
	ld -nostdlib -o os.img ipl.o -Tlnk.ls
	
ipl.o: ipl.s
	as -o ipl.o ipl.s

.PHONY: run
run:
	qemu-system-x86_64 -boot a -fda os.img

.PHONY: clean
clean:
	rm -f *~
	rm -f ipl.img
	rm -f harios.sys
	rm -f os.img
	rm -f *.o
	rm -f a.out
