# Dijkstra's shortest path implementation v 2.0
# IBRAHIM HAWARI
	
		.data
u:		.space		192
v:		.space		192
w:		.space		32
tmp:		.space		24
tmpint:		.space		24
i:		.word		0
j:		.word		0
k:		.word		0
size:		.word		0
d:		.word		0
p:		.space		64
m:		.space		1024
st:		.space		24
fn:		.space		24
data:		.space		80
path:		.space		64
parent:		.space		32
dist:		.space		32
set:		.space		32
di:		.word		0
dcount:		.word		0
dmin:		.word		0
du:		.word		0
dv:		.word		0
pc:		.asciiz		"Enter up to 8 paths in the format CITY1 CITY2 LENGTH:\n"
pst:		.asciiz		"Where are you currently located?\n"
pfn:		.asciiz		"Where do you want to go?\n"
pr:		.asciiz		"The best route to your destination is:\n"
pda:		.asciiz		"Total distance: "
pdb:		.asciiz		" mi\n"
newline:	.asciiz		"\n"
empty:		.asciiz		""

		.text
main:		la		$a0, pc 		# prompt city
		ori		$v0, $zero, 4
		syscall
		sw		$zero, i
gcfor:		lw		$t0, i
		bge		$t0, 8, gcendfor
		la		$a0, tmp		# fgets to tmp
		ori		$a1, $zero, 24
		ori		$v0, $zero, 8
		syscall
		ori		$t5, $zero 3		# if break statement
		lb		$t8, tmp($t5)
		beq		$t8, 10, gcendfor	# break
		sw		$zero, j
		sw		$zero, k
gcforA:		lw		$t1, j
		lw		$t2, k
		lb		$t8, tmp($t2)
		beq		$t8, 32, gcendforA
		mulu		$t9, $t0, 24		# i * M
		addu		$t9, $t9, $t1
		sb		$t8, u($t9)		# u[i][j] = tmp[k];
		addiu		$t1, $t1, 1
		addiu		$t2, $t2, 1
		sw		$t1, j
		sw		$t2, k
		beq		$zero, $zero, gcforA
gcendforA:	mulu		$t9, $t0, 24		# i * M
		addu		$t9, $t9, $t1
		sb		$zero, u($t9)		# u[i][j] = '\0';
		sw		$zero, j
		addiu		$t2, $t2, 1
		sw		$t2, k
gcforB:		lw		$t1, j
		lw		$t2, k
		lb		$t8, tmp($t2)
		beq		$t8, 32, gcendforB
		mulu		$t9, $t0, 24		# i * M
		addu		$t9, $t9, $t1
		sb		$t8, v($t9)		# v[i][j] = tmp[k];
		addiu		$t1, $t1, 1
		addiu		$t2, $t2, 1
		sw		$t1, j
		sw		$t2, k
		beq		$zero, $zero, gcforB
gcendforB:	mulu		$t9, $t0, 24		# i * M
		addu		$t9, $t9, $t1
		sb		$zero, v($t9)		# v[i][j] = '\0';
		sw		$zero, j
		addiu		$t2, $t2, 1
		sw		$t2, k
gcforC:		lw		$t1, j
		lw		$t2, k
		lb		$t8, tmp($t2)
		beq		$t8, 10, gcendforC
		sb		$t8, tmpint($t1)	# tmpint[j] = tmp[k];
		addiu		$t1, $t1, 1
		addiu		$t2, $t2, 1
		sw		$t1, j
		sw		$t2, k
		beq		$zero, $zero, gcforC
gcendforC:	sb		$zero, tmpint($t1)
		la		$a0, tmpint
		jal		atoi
		sll		$s0, $t0, 2
		sw		$v0, w($s0)
		addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, gcfor
gcendfor:	lw		$t0, i
		sw		$t0, size
		sw		$zero, i
ipfor:		lw		$t0, i
		bge		$t0, 16, ipendfor
		ori		$t8, 32
		sll		$s0, $t0, 2
		la		$t8, empty
		sw		$t8, p($s0)		# p[i] = "";
		addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, ipfor
ipendfor:	lw		$t3, size
		sw		$zero, i
		sw		$zero, d
upfor:		lw		$t0, i
		lw		$t4, d
		bge		$t0, $t3, upendfor
		sw		$zero, j
upforA:		lw		$t1, j
		bge		$t1, 8, upendforA
		sll		$s0, $t1, 2
		lw		$a0, p($s0)
		mulu		$t8, $t0, 24
		la		$a1, u($t8)
		jal		strcmp
		beq		$v0, $zero, upendforA
		addiu		$t1, $t1, 1
		sw		$t1, j
		beq		$zero, $zero, upforA
upendforA:	blt		$t1, 8, upcontinue
		mulu		$t9, $t0, 24		# p[d] = u[i];
		la		$t9, u($t9)
		sll		$s0, $t4, 2
		sw		$t9, p($s0)
		addiu		$t4, $t4, 1
		sw		$t4, d
upcontinue:	addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, upfor
upendfor:	sw		$zero, i
vpfor:		lw		$t0, i
		lw		$t4, d
		bge		$t0, $t3, vpendfor
		sw		$zero, j
vpforA:		lw		$t1, j
		bge		$t1, 8, vpendforA
		sll		$s0, $t1, 2
		lw		$a0, p($s0)
		mulu		$t8, $t0, 24
		la		$a1, v($t8)
		jal		strcmp
		beq		$v0, $zero, vpendforA
		addiu		$t1, $t1, 1
		sw		$t1, j
		beq		$zero, $zero, vpforA
vpendforA:	blt		$t1, 8, vpcontinue
		mulu		$t9, $t0, 24		# p[d] = v[i];
		la		$t9, v($t9)
		sll		$s0, $t4, 2
		sw		$t9, p($s0)
		addiu		$t4, $t4, 1
		sw		$t4, d
vpcontinue:	addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, vpfor
vpendfor:	lw		$t4, d
		sw		$zero, i
bmfor:		lw		$t0, i
		bge		$t0, $t3, bmendfor
		sw		$zero, j
bmforA:		lw		$t1, j
		bge		$t1, $t4, bmendforA
		sll		$s0, $t1, 2
		lw		$a0, p($s0)
		mulu		$t8, $t0, 24
		la		$a1, u($t8)
		jal		strcmp
		beq		$v0, $zero, bmendforA
		addiu		$t1, $t1, 1
		sw		$t1, j
		beq		$zero, $zero, bmforA
bmendforA:	sw		$zero, k
bmforB:		lw		$t2, k
		bge		$t2, $t4, bmendforB
		sll		$s0, $t2, 2
		lw		$a0, p($s0)
		mulu		$t8, $t0, 24
		la		$a1, v($t8)
		jal		strcmp
		beq		$v0, $zero, bmendforB
		addiu		$t2, $t2, 1
		sw		$t2, k
		beq		$zero, $zero, bmforB
bmendforB:	sll		$s0, $t0, 2
		lw		$t8, w($s0)
		mulu		$t9, $t1, 16		# j * M
		addu		$t9, $t9, $t2
		sll		$s0, $t9, 2
		sw		$t8, m($s0)		# m[j][k] = w[i];
		mulu		$t9, $t2, 16		# k * M
		addu		$t9, $t9, $t1
		sll		$s0, $t9, 2
		sw		$t8, m($s0)		# m[k][j] = w[i];
		addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, bmfor
bmendfor:	sw		$zero, i
mifor:		lw		$t0, i
		bge		$t0, 16, miendfor
		sw		$zero, j
miforA:		lw		$t1, j
		bge		$t1, 16, miendforA
		mulu		$t9, $t0, 16		# i * M
		addu		$t9, $t9, $t1
		sll		$s0, $t9, 2
		lw		$t8, m($s0)		# load m[i][j] to compare in if
		bgt		$t8, $zero, micontinue
		ori		$t8, 200
		sll		$s0, $t9, 2
		sw		$t8, m($s0)		# set m[i][j] equal to infinity
micontinue:	addiu		$t1, $t1, 1
		sw		$t1, j
		beq		$zero, $zero, miforA
miendforA:	addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, mifor
miendfor:	la		$a0, pst
		ori		$v0, $zero, 4
		syscall
		la		$a0, st			# fgets to st
		ori		$a1, $zero, 24
		ori		$v0, $zero, 8
		syscall
		la		$a0, pfn
		ori		$v0, $zero, 4
		syscall
		la		$a0, fn			# fgets to fn
		ori		$a1, $zero, 24
		ori		$v0, $zero, 8
		syscall
		sw		$zero, i
fstfor:		lw		$t0, i
		lb		$t8, st($t0)
		beq		$t8, 10, fstendfor
		addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, fstfor
fstendfor:	sb		$zero, st($t0)		# st[i] = '\0';
		sw		$zero, i
ffnfor:		lw		$t0, i
		lb		$t8, fn($t0)
		beq		$t8, 10, ffnendfor
		addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, ffnfor
ffnendfor:	sb		$zero, fn($t0)		# fn[i] = '\0';
		jal		dijkstra
		lw		$t4, d
		sw		$zero, i
ifnfor:		lw		$t0, i
		bge		$t0, $t4, ifnendfor
		sll		$s0, $t0, 2
		lw		$a0, p($s0)
		la		$a1, fn
		jal		strcmp
		beq		$v0, $zero, ifnendfor
		addiu		$t0, $t0, 1
		sw		$t0, i
		beq		$zero, $zero, ifnfor
ifnendfor:	sw		$zero, j
bpfor:		lw		$t0, i
		lw		$t1, j
		beq		$t0, -1, bpendfor
		sll		$s0, $t0, 2
		lw		$t8, p($s0)		# path[j] = p[i];
		sll		$s0, $t1, 2
		sw		$t8, path($s0)
		sll		$s0, $t0, 2
		lw		$t0, data($s0)		# i = data[i];
		sw		$t0, i
		addiu		$t1, $t1, 1
		sw		$t1, j
		beq		$zero, $zero, bpfor
bpendfor:	la		$a0, pr
		ori		$v0, $zero, 4
		syscall
		addi		$t1, $t1, -1
		sw		$t1, i
prfor:		lw		$t0, i
		blt		$t0, $zero, prendfor
		sll		$s0, $t0, 2
		lw		$a0, path($s0)		# print stuff
		ori		$v0, $zero, 4
		syscall
		la		$a0, newline		# print newline
		ori		$v0, $zero, 4
		syscall
		addi		$t0, $t0, -1
		sw		$t0, i
		beq		$zero, $zero, prfor
prendfor:	la		$a0, pda
		ori		$v0, $zero, 4
		syscall
		sll		$s0, $t4, 2
		lw		$a0, data($s0)
		ori		$v0, $zero, 1
		syscall
		la		$a0, pdb
		ori		$v0, $zero, 4
		syscall
end:		ori		$v0, $zero, 10
		syscall

		.text
dijkstra:	addiu		$sp, $sp, -28
		sw		$ra, 0($sp)
		sw		$t0, 4($sp)
		sw		$t1, 8($sp)
		sw		$t2, 12($sp)
		sw		$t3, 16($sp)
		sw		$t4, 20($sp)
		sw		$t5, 24($sp)
		lw		$t5, d
		sw		$zero, di
idsfor:		lw		$t0, di
		bge		$t0, $t5, idsendfor
		ori		$t8, $zero, 200		# dist[i] = INF
		sll		$s0, $t0, 2
		sw 		$t8, dist($s0)
		sw		$zero, set($s0)		# set[i] = 0
		addiu		$t0, $t0, 1
		sw		$t0, di
		beq		$zero, $zero, idsfor
idsendfor:	sw		$zero, di
istfor:		lw		$t0, di
		bge		$t0, $t5, istendfor
		sll		$s0, $t0, 2
		lw		$a0, p($s0)
		la		$a1, st
		jal		strcmp
		beq		$v0, $zero, istendfor
		addiu		$t0, $t0, 1
		sw		$t0, di
		beq		$zero, $zero, istfor
istendfor:	ori		$t8, $zero, -1		# parent[i] = -1;
		sll		$s0, $t0, 2
		sw		$t8, parent($s0)
		sll		$s0, $t0, 2
		sw		$zero, dist($s0)	# dist[i] = 0;
		addi		$t6, $t5, -1
		sw		$zero, dcount
djfor:		lw		$t1, dcount
		bge		$t1, $t6, djendfor
		ori		$t2, $zero, 200
		sw		$t2, dmin
		sw		$zero, dv
djforA:		lw		$t2, dmin
		lw		$t4, dv
		bge		$t4, $t5, djendforA
		sll		$s0, $t4, 2
		lw		$t7, set($s0)		# if statement
		bne		$t7, $zero, djcontinueA
		lw		$t8, dist($s0)
		bgt		$t8, $t2, djcontinueA
		sll		$s0, $t4, 2
		lw		$t2, dist($s0)		# min = dist[v]
		sw		$t2, dmin
		move		$t3, $t4		# u = v
		sw		$t3, du
djcontinueA:	addiu		$t4, $t4, 1
		sw		$t4, dv
		beq		$zero, $zero, djforA
djendforA:	ori		$t8, $zero, 1		# set[u] = 1;
		sll		$s0, $t3, 2
		sw		$t8, set($s0)
		sw		$zero, dv
djforB:		lw		$t4, dv
		bge		$t4, $t5, djendforB
		sll		$s0, $t4, 2
		lw		$t8, set($s0)		# !set[v]
		bne		$t8, $zero, djcontinueB
		mulu		$t9, $t3, 16
		addu		$t9, $t9, $t4
		sll		$s0, $t9, 2
		lw		$t9, m($s0)		# m[u][v]
		beq		$t9, $zero, djcontinueB
		sll		$s0, $t3, 2
		lw		$s1, dist($s0)		# dist[u]
		beq		$s1, 200, djcontinueB
		addu		$s2, $t9, $s1		# dist[u] + m[u][v]
		sll		$s0, $t4, 2
		lw		$s3, dist($s0)		# dist[v]
		bge		$s2, $s3, djcontinueB
		sll		$s0, $t4, 2
		sw		$t3, parent($s0)
		sw		$s2, dist($s0)
djcontinueB:	addiu		$t4, $t4, 1
		sw		$t4, dv
		beq		$zero, $zero, djforB
djendforB:	addiu		$t1, $t1, 1
		sw		$t1, dcount
		beq		$zero, $zero, djfor
djendfor:	sw		$zero, di
bdfor:		lw		$t0, di
		bge		$t0, $t5, bdendfor
		sll		$s0, $t0, 2
		lw		$t8, parent($s0)	# data[i] = parent[i];
		sw		$t8, data($s0)
		addiu		$t0, $t0, 1
		sw		$t0, di
		beq		$zero, $zero, bdfor
bdendfor:	sw		$zero, di
gifnfor:	lw		$t0, di
		bge		$t0, $t5, gifnendfor
		sll		$s0, $t0, 2
		lw		$a0, p($s0)
		la		$a1, fn
		jal		strcmp
		beq		$v0, $zero, gifnendfor
		addiu		$t0, $t0, 1
		sw		$t0, di
		beq		$zero, $zero, gifnfor
gifnendfor:	sll		$s0, $t0, 2
		lw		$t8, dist($s0)		# data[d] = dist[i];
		sll		$s0, $t5, 2
		sw		$t8, data($s0)
rdijkstra:	lw		$ra, 0($sp)
		lw		$t0, 4($sp)
		lw		$t1, 8($sp)
		lw		$t2, 12($sp)
		lw		$t3, 16($sp)
		lw		$t4, 20($sp)
		lw		$t5, 24($sp)
		addiu		$sp, $sp, 28
		jr		$ra
		
		.text
atoi:		addi		$sp, $sp, -12
		sw		$ra, 0($sp)
		sw		$t0, 4($sp)
		sw		$t1, 8($sp)
		move		$t0, $a0
		li		$v0, 0
next:		lb		$t1, ($t0)
		blt		$t1, 48, ratoi
		bgt		$t1, 57, ratoi
		mul		$v0, $v0, 10
		add		$v0, $v0, $t1
		sub		$v0, $v0, 48
		add		$t0, $t0, 1
		b		next
ratoi:		lw		$ra, 0($sp)
		lw		$t0, 4($sp)
		lw		$t1, 8($sp)
		addiu		$sp, $sp, 12
		jr		$ra
		
		.text
strcmp:		addi		$sp, $sp, -28
		sw		$ra, 0($sp)
		sw		$t0, 4($sp)
		sw		$t1, 8($sp)
		sw		$t2, 12($sp)
		sw		$t3, 16($sp)
		sw		$t4, 20($sp)
		sw		$t5, 24($sp)
		move		$t0, $zero
		move		$t1, $a0
		move		$t2, $a1
loop:		lb		$t3($t1)
		lb		$t4($t2)
		beq		$t3, $zero, checkt2
		beq		$t4, $zero, unequal
		slt		$t5, $t3, $t4
		bne		$t5, $zero, unequal
		addi		$t1, $t1, 1
		addi		$t2, $t2, 1
		beq		$zero, $zero, loop
unequal: 	ori		$v0, 1
		j		rstrcmp
checkt2:	bne		$t4, $zero, unequal
		move		$v0, $zero
rstrcmp:	lw		$ra, 0($sp)
		lw		$t0, 4($sp)
		lw		$t1, 8($sp)
		lw		$t2, 12($sp)
		lw		$t3, 16($sp)
		lw		$t4, 20($sp)
		lw		$t5, 24($sp)
		addiu		$sp, $sp, 28
		jr		$ra