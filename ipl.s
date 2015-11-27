.code16
.text

.equ CYLS, 10

# for FAT12 format floppy disk

	jmp entry
	.byte 0x90
	.ascii "HELLOIPL"	# name of boot sector
	.word 512			# size per 1 sector
	.byte 1				# cluster
	.word 1				# start of FAT
	.byte 2				# num of FAT
	.word 224			# size of root directory
	.word 2880			# drive size
	.byte 0xf0			# media type
	.word 9				# len of FAT area
	.word 18			# secter num per track
	.word 2				# head num
	.int 0				# always "0"
	.int 2880			# drive size
	.byte 0, 0, 0x29
	.int 0xffffffff		# volume serial number
	.ascii "HELLO-OS   "	# disk name
	.ascii "FAT12   "	# format name
	.skip 18, 0x00		# 18 bytes space

# main program
entry:
	movw $0, %ax		# init register
	movw %ax, %ss
	movw $0x7c00, %sp
	movw %ax, %ds

# read disk
	movw $0x0820, %ax
	movw %ax, %es
	movb $0, %ch		# cylinder 0
	movb $0, %dh		# head 0
	movb $2, %cl		# sector 2
readloop:
	movw $0, %si		# for fail count
retry:
	movb $0x02, %ah		# read disk
	movb $1, %al		# 1 sector
	movw $0, %bx
	movb $0x00, %dl		# drive A
	int $0x13			# call disk bios
	jnc next			# go to fin if no error
	addw $1, %si		# increment si
	cmp	$5, %si			# compare si with 5
	jae error			# if si >= 5 go to error
	movb $0x00, %ah
	movb $0x00, %dl		# drive A
	int $0x13			# reset drive
	jmp retry
next:
	movw %es, %ax		# address +0x200
	addw $0x0020, %ax
	movw %ax, %es		# no operand like "addw $0x020, %es"
	addb $1, %cl		# increment cl
	cmp $18, %cl		# compare cl with 18
	jbe readloop		# if cl <= 18 go to readloop
	movb $1, %cl
	addb $1, %dh
	cmp $2, %dh
	jb readloop			# if dh < 2 go to readloop
	movb $0, %dh
	addb $1, %ch
	cmp $CYLS, %ch		# if ch < CYLS go to readloop
	jb readloop
# sleep
fin:
	jmp 0xC200
	hlt					# stop cpu
	jmp fin				# loop
error:
	mov $msg, %si
putloop:
	movb (%si), %al
	addw $1, %si
	cmpb $0, %al
	je fin
	movb $0x0e, %ah		# one char function
	movw $15, %bx		# color code
	int $0x10			# call video bios
	jmp putloop
	
# message
.data
msg:
	.string "\n\nload error\n"
