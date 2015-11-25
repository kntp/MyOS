.code16
.text
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

	movb $0x02, %ah		# read disk
	movb $1, %al		# 1 sector
	movw $0, %bx
	movb $0x00, %dl		# drive A
	int $0x13			# call disk bios
	jc error
	
# sleep
fin:
	hlt
	jmp fin
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
