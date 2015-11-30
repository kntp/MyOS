.code32
.globl io_hlt
.globl write_mem8

.text
# HLT
io_hlt:
	hlt
	ret

write_mem8:
	movl	4(%esp),	%ecx
	movb	8(%esp),	%al
	movb	%al,		(%ecx)
	ret
