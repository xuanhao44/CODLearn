# 第二章

## 1. 填空题 

假设有一个字长的数据 0xabcdef12 采用小端对齐方式连续存储在地址 0x0000 至 0x0003 的内存中，

- 则地址 0x0002 中存储的字节数据是 0x_____________。

- 如果该数据采用**大端**对齐方式存储，则地址 0x0003中存储的字节数据是 0x_____________。

答：字节排布。

|      | 0x0003 | 0x0002 | 0x0001 | 0x0000 |
| :--: | :----: | :----: | :----: | :----: |
| 小端 |   ab   |   cd   |   ef   |   12   |
| 大端 |   12   |   ef   |   cd   |   ab   |

- 则地址 0x0002 中存储的字节数据是 0xcd。

- 如果该数据采用**大端**对齐方式存储，则地址 0x0003中存储的字节数据是 0x12。

## 2. 填空题

给定 RV64 汇编指令如下: 

```asm
L1: addi x11,x11,-1
    beq  x10,x11,L1
```

其中，`beq x10,x11,L1` 对应的机器指令的十六进制表示为 0x_____________。

答：

beq 指令格式：`beq rs1,rs2,label`。

- 故 rs2 为 x11（01011），rs1 为 x10（01010）。
- 立即数为 -2，即 -2 * 2 bytes（1_1_111111_1110）。

查表：

| imm[12\|10:5] | rs2  | rs1  | 000  | imm[4:1\|11] | 1100011 |
| :-----------: | :--: | :--: | :--: | :----------: | :-----: |

对应为：

| 1\|111111 | 01011 | 01010 | 000  | 1110\|1 | 1100011 |
| :-------: | :---: | :---: | :--: | :-----: | :-----: |

二进制数为：1111_1110_1011_0101_0000_1110_1110_0011

十六进制为：0xFEB50EE3

## 3. 填空题

假设有如下寄存器内容:

x5 = 0x00000000AAAAAAAA, 

x6 = 0x1234567812345678。

1. 对于上面的寄存器值，执行以下指令后，x7 的值是 0x_____________。

    ```asm
    slli x7,x5,4
    or x7,x7,x6
    ```

2. 对于上面的寄存器值，执行以下指令后，x7 的值是 0x_____________。

    ```asm
    slli x7,x6,4
    ```

3. 对于上面的寄存器值，执行以下指令后，x7 的值是 0x_____________。

    ```asm
    srli x7,x5,3 
    andi x7,x7,0x7EF
    ```

答：

1. 逻辑左移 4 位，十六进制移动一位，故 x7 = 0x0000000AAAAAAAA0

   按位或需要展开，与 0 相或不变：

   |  0   |  0   |  0   |  0   |  0   |  0   |  0   |  A   |  A   |  A   |  A   |  A   |  A   |  A   |  A   |  0   |
   | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |
   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  ?   |  ?   |  ?   |  ?   |  ?   |  ?   |  ?   |  ?   |  8   |

   |      | 1 or A | 2 or A | 3 or A | 4 or A | 5 or A | 6 or A | 7 or A | 8 or A |
   | :--: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |
   | NUM  |  0001  |  0010  |  0011  |  0100  |  0101  |  0110  |  0111  |  1000  |
   |  A   |  1010  |  1010  |  1010  |  1010  |  1010  |  1010  |  1010  |  1010  |
   | RET  |  1011  |  1010  |  1011  |  1110  |  1111  |  1110  |  1111  |  1010  |
   |      |   B    |   A    |   B    |   E    |   F    |   E    |   F    |   A    |

   所以结果是：0x1234567ABABEFEF8

   |  0   |  0   |  0   |  0   |  0   |  0   |  0   |  A   |  A   |  A   |  A   |  A   |  A   |  A   |  A   |  0   |
   | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |
   |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  A   |  B   |  A   |  B   |  E   |  F   |  E   |  F   |  8   |


2. 逻辑左移 4 位，十六进制移动一位，故 x7 = 0x2345678123456780
3. 过程：
   - 逻辑右移 3 位：x5 最后 8 位是 1010_1010，移动后是 0101_0101，即 55；x5 第 33-40 位是 1010_1010，移动后是 0001_0101，即 15；第 41-56(共 16 位) 位每四位和最后 8 位一致。x7 此时为 0x000000001515151555。
   - 按位与：0x7EF 前面的位数用 0 拓展，即 0x00000000000007EF，显然只需要考虑最后 12 位（很遗憾前一步没啥用），就剩 555 与 7EF 按位与，得 545，所以 x7 为 0x0000000000000545。

## 4. 填空题

假设 x5 保存 0x0000000000101000。

以下指令完成后 x6 的十进制值是_____________。

```asm
bne x5, x0, ELSE
jal x0, DONE
ELSE: ori x6, x0, 2
DONE:
```

答：

x5 不等于 0，执行 ELSE；显然 00 和 10 按位或的结果是 10，即 2。

## 5. 填空题

考虑以下 RISC-V 循环：

```asm
LOOP: beq x6, x0, DONE
addi x6, x6, -1 
addi x5, x5, 2 
jal x0, LOOP
DONE: 
```

1. 假设 x6 初始值为十进制的 10，x5 初始值为 0，那么 x5 的最终值是十进制数_____________。
2. 假设寄存器 x6 初始值为 N，总共执行了_____________条 RISC-V 指令。

答：

1. 一共十次循环，每次 x5 都加 2，故最终 x5 = 20。
2. 4N + 1。


## 6. 主观题

给定十六进制机器指令 0x001080A3，查表写出其对应的 RV64 汇编指令。

答：

- 最后 8 位为 A3，即 1010_0011，故 opcode = 0100011，查表知为 S 型指令。
- 查表，按照  S 型指令格式展开为 0000000_00001_00001_000_00001_0100011
  - rs2 为 x1，rs2 为 x1；
  - func3 为 000，故操作码为 sb；
  - 立即数为 1；
- 所以指令为 `sb x1,1(x1)`。

## 7. 主观题

假设变量 f, g 分别分配给寄存器 x5，x6，数组A和B的基地址分别在寄存器 x10 和 x11 中。

对于以下 C 语句,按要求补充相应的 RISC-V 汇编代码。 

 注意：long long int为64位。  // C语言 

// long long int A[1024], B[1024];

 B[g] = A[f] + A[f-1];

```asm
slli x30, x5, 3    # x30 = f * 8
add  x30, x10, x30 # x30 = &A[f]
slli x31, x6, 3    # x31 = g * 8
add  x31, x11,x31  # 计算 B[g] 地址，x31 作为目标寄存器
ld   x5,  0(x30)   # 载入 A[f] 数据，x5 作为目标寄存器
addi x12, x30,-8   # 计算 &A[f-1]，x12 作为目标寄存器
ld   x30, 0(x12)   # 载入 A[f-1]，x30 作为目标寄存器
add  x30, x5,x30   # 加法计算，x30 作为目标寄存器
sd   x30, 0(x31)   # 将计算结果存储到 B[g] 里
```

## 8. 主观题

编写一段汇编程序,给定一个具有 10 个元素的 long long int 型数组。

已知该数组中分别存储了 4 2 7 5 8 -9 11 32 20 18，用 RARS 写出一个可以运行的代码，将数组最大值存储在 x10 中。（将 RARS 软件中的可以运行的完整代码以及寄存器结果截图上传）

答：

```asm
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
```

寄存器结果截图略。