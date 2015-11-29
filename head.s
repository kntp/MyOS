# os asm part

.equ	BOTPAK,	0x00280000
.equ	DSKCAC,	0x00100000
.equ	DSKCAC0,0x00008000

# BOOT_INFO
.equ	CYLS,	0x0ff0
.equ	LEDS,	0x0ff1
.equ	VMODE,	0x0ff2		# color info
.equ	SCRNX,	0x0ff4		# screen x
.equ	SCRNY,	0x0ff6		# screen y
.equ	VRAM,	0x0ff8		# buffer start address

.text
.code16
head:
	movb	$0x13,	%al		# VGA 320x200x8bit color
	movb	$0x00,	%ah
	int		$0x10

	movb	$8,		(VMODE)	# memo screen mode
	movw	$320,	(SCRNX)
	movw	$200,	(SCRNY)
	movl	$0x000a0000,	(VRAM)

# ask bios of keyboard led status

	movb	$0x02,	%ah
	int		$0x16			# keyboard bios
	movb	%al,	(LEDS)

# go to 32bit protectmode
	# disable interrupt PIC
	movb	$0xff,	%al
	outb	%al,	$0x21
	nop
	outb	%al,	$0xa1
	cli						# disable interrupt on cpu level

	# A20 gate on
	call	waitkbdout
	movb	$0xd1,	%al
	outb	%al,	$0x64
	call	waitkbdout
	movb	$0xdf,	%al
	outb	%al,	$0x60	# enable A20
	call	waitkbdout

.arch	i486
	lgdtl	(GDTR0)					# setup temporary GDT
	movl	%cr0,			%eax
	andl	$0x7fffffff,	%eax	# bit31 -> 0 (inhibit paging)
	orl		$0x00000001,	%eax	# bit0 -> 1 (go to protect mode)
	movl	%cr0,			%eax
	jmp		pipelineflash
pipelineflash:
	movw	$1*8,			%ax		# R/W segment 32bit
	movw	%ax,			%ds
	movw	%ax,			%es
	movw	%ax,			%fs
	movw	%ax,			%gs
	movw	%ax,			%ss

# transfer bootpack
	movl	$bootpack,		%esi	# src
	movl	$BOTPAK,		%edi	# dst
	movl	$512*1024/4,	%ecx
	call	memcpy

# trans boot sector
	movl	$0x7c00,		%esi	# src
	movl	$DSKCAC,		%edi	# dst
	movl	$512/4,			%ecx
	call	memcpy

# rest of all
	movl	$DSKCAC0+512,	%esi	# src
	movl	$DSKCAC+512,	%edi	# dst
	movl	$0x00,			%ecx
	movb	(CYLS),			%cl
	imull	$512*18*2/4,	%ecx	# cylinder -> byte/4
	subl	$512/4,			%ecx	# sub IPL size
	call	memcpy

# start bootpack
	movl	$BOTPAK,		%ebx
	movl	$0x11a8,		%ecx
	addl	$3,				%ecx	# ecx += 3
	shrl	$2,				%ecx	# ecx /= 4
	jz		skip					# no data to send
	movl	$0x10c8,		%esi	# src
	addl	%ebx,			%esi
	movl	$0x00310000,	%edi	# dst
	call	memcpy
skip:
	movl	$0x00310000,	%edi	# stack def val
	ljmpl	$2*8,			$0x00000000

#######################################
# function

waitkbdout:
	inb		$0x64,			%al
	andb	$0x02,			%al
	inb		$0x60,			%al
	jnz		waitkbdout
	ret

memcpy:
	movl	(%esi),			%eax
	addl	$4,				%esi
	movl	%eax,			(%edi)
	addl	$4,				%edi
	subl	$1,				%ecx
	jnz		memcpy
	ret

#######################################
# GDT
.align 8
GDT0:
.skip 8, 0x00
	.word 0xffff, 0x0000, 0x9200, 0x00cf	# W/R segment 32bit
	.word 0xffff, 0x0000, 0x9a28, 0x0047	# executable segment 32bit

	.word 0x0000
GDTR0:
	.word 8*3-1
	.int GDT0

.align 8
bootpack:
