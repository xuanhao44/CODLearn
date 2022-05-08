.data
v:
	.dword 4,2,7,5,8,-9,11,32,20,18
	.space 80

.text
la x12,v # v[] 保存在 x12
addi x11,x0,10 # n 保存在 x11
jal x1 sort
j Done

swap:
	slli x6,x11,3  # x6 = k * 8 
	add  x6,x12,x6 # x6 = v + (k * 8) 
	ld   x5,0(x6)  # x5(temp) = v[k] 
	ld   x7,8(x6)  # x7 = v[k + 1]
	sd   x7,0(x6)  # v[k] = x7 
	sd   x5,8(x6)  # v[k + 1] = x5(temp)
	jalr x0,0(x1)  # 返回调用函数

# 保存寄存器（入栈）
sort: 
	addi sp ,sp,-40    # 在栈中留出 5 个寄存器（双字）的空间
	sd   x1 ,32(sp)    # 保存 x1  的值（入栈）
	sd   x22,24(sp)    # 保存 x22 的值（入栈）
	sd   x21,16(sp)    # 保存 x21 的值（入栈）
	sd   x20,8(sp)     # 保存 x20 的值（入栈）
	sd   x19,0(sp)     # 保存 x19 的值（入栈）
# 移动参数
mv x21,x12           # 复制 x12 中的值到 x21
mv x22,x11           # 复制 x11 中的值到 x22
# 外循环
li x19,0             # i = 0
for1tst:
	bge  x19,x22,exit1 # 如果 x19 ≥ x22(i ≥ n)，跳转到 exit1
# 内循环
	addi x20,x19,-1    # j = i - 1
for2tst:
	blt  x20,x0,exit2  # 如果 x20 < 0 (j < 0)，跳转到 exit2
	slli x5 ,x20,3     # x5 = j * 8
	add  x5 ,x21,x5    # x5 = v + (j * 8)
	ld   x6 ,0(x5)     # x6 = v[j]
	ld   x7 ,8(x5)     # x7 = v[j + 1]
	ble  x6 ,x7,exit2  # 如果 x6 ≤ x7，跳转到 exit2
# 参数传递和调用
	mv   x12,x21       # swap 的第一个参数是 v
	mv   x11,x20       # swap 的第二个参数是 j
	jal  x1 ,swap      # 调用 swap
# 内循环增值
	addi x20,x20,-1    # j -= 1
	j    for2tst       # 跳转到内层循环 for2tst
# 外循环增值
exit2: 
	addi x19,x19,1     # i += 1
	j    for1tst       # 跳转到外层循环的判断语句
# 恢复寄存器
exit1:
	ld   x19,0(sp)     # 恢复 x19（出栈）
	ld   x20,8(sp)     # 恢复 x20（出栈）
	ld   x21,16(sp)    # 恢复 x21（出栈）
	ld   x22,24(sp)    # 恢复 x22（出栈）
	ld   x1 ,32(sp)    # 恢复 x1 （出栈）
	addi sp ,sp,40     # 恢复栈指针
# 过程返回
jalr x0,0(x1)        # 返回调用线程

Done:
	ld   x10,72(x12)   # 数组最大值存储在 x10 中
	