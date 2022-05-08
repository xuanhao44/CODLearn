.data
x:
    .byte  0
    .space 13
y:
    .byte '0','1','2','3','4','5','6','F','a','d','f',0
    .space 13

.text
la x10,x
la x11,y
addi x19,zero,5
addi x20,zero,5
#jal x1,strcpy
jal x1 strcpy
j Done

strcpy:
       addi sp,sp,-8
       sd   x19,0(sp)
       add  x19,x0,x0
L1:
       add  x5,x19,x11
       lbu  x6,0(x5)
       add  x7,x19,x10
       sb   x6,0(x7)
       beq  x6,x0,L2
       addi x19,x19,1
       jal  x0,L1
L2:
       ld   x19,0(sp)
       addi sp,sp,8
       jalr x0,0(x1)

Done:
