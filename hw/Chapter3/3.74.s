	.file	"3.74.c"
	.text
	.globl	find_range
	.type	find_range, @function
find_range:
.LFB0:
	.cfi_startproc
	endbr64
#APP
# 5 "3.74.c" 1
	vxorps %xmm1, %xmm1, %xmm1
	vcomiss %xmm1, %xmm0
	cmovp $3, %eax
	cmovg $2, %eax
	cmove $1, $[result]
	cmovl $0, %eax
	
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE0:
	.size	find_range, .-find_range
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
