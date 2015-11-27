# os asm part

# BOOT_INFO
.equ	CYLS,	0x0ff0
.equ	LEDS,	0x0ff1
.equ	VMODE,	0x0ff2		# color info
.equ	SCRNX,	0x0ff4		# screen x
.equ	SCRNY,	0x0ff6		# screen y
.equ	VRAM,	0x0ff8		# buffer start address

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

fin:
	hlt
	jmp		fin
	
