	.file	"3.60.c"
	.text
	.globl	loop
	.type	loop, @function
loop:
.LFB0:
	.cfi_startproc
	endbr64
	movl	$1, %eax
	movl	$0, %edx
	jmp	.L2
.L3:
	movq	%rax, %rcx
	andq	%rdi, %rcx
	orq	%rcx, %rdx
	movl	%esi, %ecx
	andl	$15, %ecx
	salq	%cl, %rax
.L2:
	testq	%rax, %rax
	jne	.L3
	movq	%rdx, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	loop, .-loop
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
