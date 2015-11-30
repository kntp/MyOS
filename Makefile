os.img: ipl.bin os.sys
	mformat -f 1440 -C -B ipl.bin -i os.img ::
	mcopy os.sys -i os.img ::

os.sys: head.bin boot.bin
	cat head.bin boot.bin > os.sys

ipl.bin: ipl.o lnk.ls
	ld -nostdlib -o ipl.bin ipl.o -Tlnk.ls -Map=ipl.map
	
head.bin: head.o head.ls
	ld -nostdlib -o head.bin head.o -Thead.ls -Map=head.map

boot.bin: func.o boot.o
	ld -o boot.bin -e Main --oformat=binary boot.o func.o -Map=boot.map

ipl.o: ipl.s
head.o: head.s
func.o: func.s
func.s: func.h
boot.o: boot.c
bootpack.c: func.h

.PHONY: run
run:
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
	as -o $@ $<
.c.o:
	gcc $< -nostdlib -Wl,--oformat=binary -c -o $@
