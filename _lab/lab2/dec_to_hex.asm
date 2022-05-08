.data
	number: .word 200111407

.text
MAIN:
	lui  t0,0x00002 # address
	lw   a0,0x0(t0) # load

	jal  ra, FUNC
	jal  x0, Final

##################
# param:a0
# return:s3
FUNC:
	addi a3,x0,16   # param
	addi a5,a0,0    # =
	addi a6,x0,0    # i = 0
	Loop:
		beq  a5,x0,Done # 0 end
		rem  a4,a5,a3   # mod 16,a4
		sll  a4,a4,a6   # left i
		add  s3,s3,a4   # add
		div  a5,a5,a3   # /16,a5
		addi a6,a6,4    # i = i + 4
		jal  x0,Loop
	Done:
		jalr zero,0(ra) # return

Final:
