	.file	"5.9.c"
	.text
	.globl	impro_merge
	.type	impro_merge, @function
impro_merge:
.LFB0:
	.cfi_startproc
	endbr64
	testq	%rcx, %rcx
	jle	.L13
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %r9
	movq	%rsi, %r10
	movq	%rdx, %rbx
	movq	%rcx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %eax
	jmp	.L5
.L3:
	addq	$1, %rdx
.L4:
	addq	$1, %rcx
	movq	%rcx, %rdi
	movq	%r11, -8(%rbx,%rcx,8)
	cmpq	%rdx, %rax
	movq	%rdx, %rsi
	cmovge	%rax, %rsi
	cmpq	%r8, %rsi
	jge	.L16
.L5:
	movq	(%r10,%rdx,8), %rsi
	leaq	0(,%rax,8), %rbp
	movq	(%r9,%rax,8), %rdi
	cmpq	%rdi, %rsi
	movq	%rdi, %r11
	cmovle	%rsi, %r11
	jle	.L3
	addq	$1, %rax
	cmpq	8(%r9,%rbp), %rsi
	jg	.L4
	jmp	.L3
.L16:
	cmpq	%r8, %rax
	jge	.L6
	movq	%rax, %r11
	subq	%rax, %rcx
	leaq	(%rbx,%rcx,8), %rsi
.L7:
	addq	$1, %rax
	movq	-8(%r9,%rax,8), %rcx
	movq	%rcx, -8(%rsi,%rax,8)
	cmpq	%rax, %r8
	jne	.L7
	leaq	(%rax,%rdi), %rcx
	subq	%r11, %rcx
.L6:
	cmpq	%r8, %rdx
	jge	.L1
	subq	%rdx, %rcx
	leaq	(%rbx,%rcx,8), %rcx
.L8:
	addq	$1, %rdx
	movq	-8(%r10,%rdx,8), %rax
	movq	%rax, -8(%rcx,%rdx,8)
	cmpq	%rdx, %r8
	jne	.L8
.L1:
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L13:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE0:
	.size	impro_merge, .-impro_merge
	.globl	merge
	.type	merge, @function
merge:
.LFB1:
	.cfi_startproc
	endbr64
	testq	%rcx, %rcx
	jle	.L29
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %r10
	movq	%rsi, %r9
	movq	%rdx, %rbx
	movq	%rcx, %rsi
	movl	$1, %ecx
	movl	$0, %edx
	movl	$0, %eax
	jmp	.L21
.L19:
	addq	$1, %rdx
	movq	%rcx, %r11
.L20:
	movq	%rdi, -8(%rbx,%rcx,8)
	addq	$1, %rcx
	cmpq	%rdx, %rax
	movq	%rdx, %rdi
	cmovge	%rax, %rdi
	cmpq	%rsi, %rdi
	jge	.L32
.L21:
	movq	(%r10,%rax,8), %r8
	movq	(%r9,%rdx,8), %rdi
	cmpq	%rdi, %r8
	jge	.L19
	addq	$1, %rax
	movq	%rcx, %r11
	movq	%r8, %rdi
	jmp	.L20
.L32:
	cmpq	%rsi, %rax
	jge	.L22
	movq	%rax, %r8
	movq	%r11, %rbp
	subq	%rax, %r11
	leaq	(%rbx,%r11,8), %rdi
.L23:
	addq	$1, %rax
	movq	-8(%r10,%rax,8), %rcx
	movq	%rcx, -8(%rdi,%rax,8)
	cmpq	%rax, %rsi
	jne	.L23
	leaq	(%rax,%rbp), %r11
	subq	%r8, %r11
.L22:
	cmpq	%rsi, %rdx
	jge	.L17
	subq	%rdx, %r11
	leaq	(%rbx,%r11,8), %rcx
.L24:
	addq	$1, %rdx
	movq	-8(%r9,%rdx,8), %rax
	movq	%rax, -8(%rcx,%rdx,8)
	cmpq	%rdx, %rsi
	jne	.L24
.L17:
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L29:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE1:
	.size	merge, .-merge
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
