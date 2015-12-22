.file "func.s"
.code32
.globl io_hlt, io_cli, io_sti, io_stihlt
.globl io_load_eflags, io_store_eflags
.globl io_in8, io_in16, io_in32
.globl io_out8, io_out16, io_out32
.globl load_gdtr, load_idtr
.globl load_cr0, store_cr0
.globl asm_inthandler21, asm_inthandler27, asm_inthandler2c
.globl memtest_sub
.extern inthandler21, inthandler27, inthandler2c

.text

# HLT
io_hlt:
	hlt
	ret

# CLI
io_cli:
	cli
	ret

# STI
io_sti:
	sti
	ret

# STI -> HLT
io_stihlt:
	sti
	hlt
	ret

# LOAD EFLAGS
io_load_eflags:
	pushf
	popl	%eax
	ret

# STORE EFLAGS
io_store_eflags:
	movl	4(%esp), %eax
	pushl	%eax
	popf
	ret

# IN ( 8bit )
io_in8:
	movl	4(%esp), %edx		# port
	xorl	%eax, %eax
	inb		%dx, %al
	ret

# IN ( 16bit )
io_in16:
	movl	4(%esp), %edx
	xorl	%eax, %eax
	inw		%dx, %ax
	ret

# IN ( 32bit )
io_in32:
	movl	4(%esp), %edx
	inl		%dx, %eax
	ret

# OUT ( 8bit )
io_out8:
	movl	4(%esp), %edx
	movb	8(%esp), %al
	outb	%al, %dx
	ret

# OUT ( 16bit )
io_out16:
	movl	4(%esp), %edx
	movl	8(%esp), %eax
	outw	%ax, %dx
	ret

# OUT ( 32bit )
	movl	4(%esp), %edx
	movl	8(%esp), %eax
	outl	%eax, %dx
	ret

#
load_gdtr:
	movw	4(%esp), %ax
	movw	%ax, 6(%esp)
	lgdt	6(%esp)
	ret

#
load_idtr:
	movw	4(%esp), %ax
	movw	%ax, 6(%esp)
	lidt	6(%esp)
	ret

#
load_cr0:
	movl	%cr0, %eax
	ret

#
store_cr0:
	movl	4(%esp), %eax
	movl	%eax, %cr0
	ret

asm_inthandler21:
	pushw	%es
	pushw	%ds
	pusha
	movl	%esp, %eax
	pushl	%eax
	movw	%ss, %ax
	movw	%ax, %ds
	movw	%ax, %es
	call	inthandler21
	popl	%eax
	popa
	popw	%ds
	popw	%es
	iret

asm_inthandler27:
	pushw	%es
	pushw	%ds
	pusha
	movl	%esp, %eax
	pushl	%eax
	movw	%ss, %ax
	movw	%ax, %ds
	movw	%ax, %es
	call	inthandler27
	popl	%eax
	popa
	popw	%ds
	popw	%es
	iret

asm_inthandler2c:
	pushw	%es
	pushw	%ds
	pusha
	movl	%esp, %eax
	pushl	%eax
	movw	%ss, %ax
	movw	%ax, %ds
	movw	%ax, %es
	call	inthandler2c
	popl	%eax
	popa
	popw	%ds
	popw	%es
	iret

memtest_sub:
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	movl	$0xaa55aa55, %esi		# pat0
	movl	$0x55aa55aa, %edi		# pat1
	movl	16(%esp), %eax			# i = start;
mts_loop:
	movl	%eax, %ebx
	addl	$0xffc, %ebx
	movl	(%ebx), %edx
	movl	%esi, (%ebx)
	xorl	$0xffffffff, (%ebx)
	cmp		(%ebx), %edi
	jne		mts_fin
	xorl	$0xffffffff, (%ebx)
	cmp		(%ebx), %esi
	jne		mts_fin
	movl	%edx, (%ebx)
	addl	$0x1000, %eax
	cmp		20(%esp), %eax
	jbe		mts_loop
	popl	%ebx
	popl	%esi
	popl	%edi
	ret
mts_fin:
	movl	%edx, (%ebx)
	popl	%ebx
	popl	%esi
	popl	%edi
	ret

