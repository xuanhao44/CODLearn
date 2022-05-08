.data
	number: .word 20

.text
MAIN:
	lui  t0,0x00002    # address
	lw   a0,0(t0)      # load word from address t0
	jal  ra, FIB       # goto FIB,return value in a0
	addi s3,a0,0       # result = s3 = a0
	jal  x0, FINAL     # END
FIB:
    addi t0,x0,3       # if n < 3
    blt  a0,t0,FIBBASE # goto FIBBASE

    addi sp,sp,-12     # stack, store 3 words
    sw   ra,8(sp)      # store ra

    sw   a0,4(sp)      # store a0, prepare for calc FIB(n-1)
    addi a0,a0,-1      # n - 1
    jal  ra,FIB        # calc FIB, and when return a0 = FIB(n-1)
    sw   a0,0(sp)      # a0 = FIB(n-1), store, prepare for calc FIB(n-1) + FIB(n-2)

    lw   a0,4(sp)      # load n into a0
    addi a0,a0,-2      # n - 2
    jal  ra,FIB        # calc FIB, and when return a0 = FIB(n-2)
    lw   t0,0(sp)      # load FIB(n-1) into t0

    add  a0,a0,t0      # calc FIB(n-1) + FIB(n-2)
    lw   ra,8(sp)      # load previous ra
    addi sp,sp,12      # stack, free

    jalr x0,0x0(ra)    # return
FIBBASE:
    addi a0,x0,1       # when n < 3, result = 1
    jalr x0,0x0(ra)    # return
FINAL:
