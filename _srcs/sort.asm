.data
v:
	.dword 4,2,7,5,8,-9,11,32,20,18
	.space 80

.text
la x12,v # v[] ������ x12
addi x11,x0,10 # n ������ x11
jal x1 sort
j Done

swap:
	slli x6,x11,3  # x6 = k * 8 
	add  x6,x12,x6 # x6 = v + (k * 8) 
	ld   x5,0(x6)  # x5(temp) = v[k] 
	ld   x7,8(x6)  # x7 = v[k + 1]
	sd   x7,0(x6)  # v[k] = x7 
	sd   x5,8(x6)  # v[k + 1] = x5(temp)
	jalr x0,0(x1)  # ���ص��ú���

# ����Ĵ�������ջ��
sort: 
	addi sp ,sp,-40    # ��ջ������ 5 ���Ĵ�����˫�֣��Ŀռ�
	sd   x1 ,32(sp)    # ���� x1  ��ֵ����ջ��
	sd   x22,24(sp)    # ���� x22 ��ֵ����ջ��
	sd   x21,16(sp)    # ���� x21 ��ֵ����ջ��
	sd   x20,8(sp)     # ���� x20 ��ֵ����ջ��
	sd   x19,0(sp)     # ���� x19 ��ֵ����ջ��
# �ƶ�����
mv x21,x12           # ���� x12 �е�ֵ�� x21
mv x22,x11           # ���� x11 �е�ֵ�� x22
# ��ѭ��
li x19,0             # i = 0
for1tst:
	bge  x19,x22,exit1 # ��� x19 �� x22(i �� n)����ת�� exit1
# ��ѭ��
	addi x20,x19,-1    # j = i - 1
for2tst:
	blt  x20,x0,exit2  # ��� x20 < 0 (j < 0)����ת�� exit2
	slli x5 ,x20,3     # x5 = j * 8
	add  x5 ,x21,x5    # x5 = v + (j * 8)
	ld   x6 ,0(x5)     # x6 = v[j]
	ld   x7 ,8(x5)     # x7 = v[j + 1]
	ble  x6 ,x7,exit2  # ��� x6 �� x7����ת�� exit2
# �������ݺ͵���
	mv   x12,x21       # swap �ĵ�һ�������� v
	mv   x11,x20       # swap �ĵڶ��������� j
	jal  x1 ,swap      # ���� swap
# ��ѭ����ֵ
	addi x20,x20,-1    # j -= 1
	j    for2tst       # ��ת���ڲ�ѭ�� for2tst
# ��ѭ����ֵ
exit2: 
	addi x19,x19,1     # i += 1
	j    for1tst       # ��ת�����ѭ�����ж����
# �ָ��Ĵ���
exit1:
	ld   x19,0(sp)     # �ָ� x19����ջ��
	ld   x20,8(sp)     # �ָ� x20����ջ��
	ld   x21,16(sp)    # �ָ� x21����ջ��
	ld   x22,24(sp)    # �ָ� x22����ջ��
	ld   x1 ,32(sp)    # �ָ� x1 ����ջ��
	addi sp ,sp,40     # �ָ�ջָ��
# ���̷���
jalr x0,0(x1)        # ���ص����߳�

Done:
	ld   x10,72(x12)   # �������ֵ�洢�� x10 ��
	