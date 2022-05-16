#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int a = 0; // x的位数
int b = 0; // y的位数

// 输出乘数数组
void print(char Y[])
{
    for (int i = 0; i < b + 1; ++i)
    {
        if (i == 1)
            printf(".");
        printf("%c", Y[i]);
    }
}

// 根据已求得的原码数组求补码
void complement(char x[], int m, int n)
{
    // 取反码
    for (int i = n + 1; i < m + 1; ++i)
        if (x[i] == '1')
            x[i] = '0';
        else
            x[i] = '1';
    // 取补码
    for (int j = m; j > n; --j)
    {
        if (x[j] == '1')
        {
            x[j] = '0';
            continue;
        }
        x[j] = '1';
        break;
    }
}

// 求被乘数和负的被乘数的补码
void complement1(int num, char x[], int m)
{
    if (num >= 0)
    {
        x[0] = '0';
        x[1] = '0';
    }
    else
    {
        x[0] = '1';
        x[1] = '1';
        num = -num;
    }
    x[2] = '.';

    // 求原码
    for (int i = 2 + m; i > 2; --i)
    {
        x[i] = num % 2 + '0';
        num /= 2;
    }
    // 求补码
    if (x[0] == '1')
        complement(x, m + 2, 2);
    printf("%s\n", x);
}

// 求乘数补码
void complement2(int num, char x[], int m)
{
    if (num >= 0)
        x[0] = '0';
    else
    {
        x[0] = '1';
        num = -num;
    }
    // 求原码
    for (int i = m; i > 0; --i)
    {
        x[i] = num % 2 + '0';
        num /= 2;
    }
    // 求补码
    if (x[0] == '1')
        complement(x, m, 0);
    print(x);
    printf("\n");
}

// 输出结果的原码形式
void print2(char x[], int m)
{
    printf("x*y = ");
    int xy = 0;
    // 求补码
    if (x[0] == '1')
    {
        complement(x, m, 0);
        printf("-");
    }
    int i = 3;
    while (x[i] == '0')
        ++i;
    for (int j = i; j < m + 1; ++j)
        printf("%c", x[j]);
    printf("\n");
    printf("convert to decimal: ");
    if (x[0] == '1')
        printf("-");
    for (int j = i; j < m + 1; ++j)
        if (x[j] == '1')
            xy += (int)pow(2, m - j);
    printf("%d\n", xy);
}

// 补码数组相加
void Add(char Z[], char X[])
{
    for (int i = a + 2; i >= 0; --i)
    {
        if (i == 2)
            continue;
        if (Z[i] + X[i] - '0' == '2')
        {
            Z[i] = '0';
            for (int j = i - 1; j >= 0; --j)
                if (Z[j] == '0')
                {
                    Z[j] = '1';
                    break;
                }
                else if (Z[j] == '1')
                    Z[j] = '0';
        }
        else
            Z[i] = Z[i] + X[i] - '0';
    }
}

void print0()
{
    printf("00.");
    for (int j = 1; j <= a; ++j)
        printf("0");
}

void XYprint(char *XY, char Z[], char Y[], int x)
{
    strcpy(XY, Z);
    for (int i = a + 3; i < a + 3 + x; ++i)
        XY[i] = Y[i - a - 3];
}

// 二进制串到整形数
unsigned Bs2Di(char s[])
{
    int i;
    unsigned num = 0;
    for (i = 0; s[i]; ++i)
        num = 2 * num + s[i] - '0';
    return num;
}

// 二进制串到十六进制串，存hs并返回
char *Bs2Hs(char bs[], char *hs)
{
    unsigned n, num = Bs2Di(bs);
    int i = 0, len, ch;
    while (num)
    {
        n = num % 16;
        if (n > 9)
            hs[i] = n + 'A' - 10;
        else
            hs[i] = n + '0';
        num /= 16;
        ++i;
    }
    hs[i] = '\0';
    len = strlen(hs);
    for (i = 0; i < len / 2; ++i)
    {
        ch = hs[i];
        hs[i] = hs[len - 1 - i];
        hs[len - 1 - i] = ch;
    }
    return hs;
}

void deletePoint(char *str)
{
    for (int i = 0; str[i] != '\0'; ++i)
        if (str[i] == '.')
            for (int j = i; str[j] != '\0'; ++j)
                str[j] = str[j + 1];
}

void Booth(int x, int y)
{
    char X[36] = {'\0'};
    char Y[34] = {'\0'};
    char _X[36] = {'\0'};
    char Z[36] = {'\0'};
    for (int i = 0; i < a + 3; ++i)
    {
        if (i == 2)
        {
            Z[i] = '.';
            continue;
        }
        Z[i] = '0';
    }

    printf("%d's complement: ", x);
    complement1(x, X, a);
    printf("%d's complement: ", y);
    complement2(y, Y, b);
    printf("%d's complement: ", -x);
    complement1(-x, _X, a);
    char yb_1 = '0';

    printf("\n");

    for (int i = 0; i < b + 1; ++i)
    {
        if (i == 0)
        {
            printf("      ");
            print0();
            printf("  ");
            print(Y);
            printf("  %c ", yb_1);
        }

        if (Y[b] == yb_1)
        {
            char tempXY[70] = {'\0'};
            XYprint(tempXY, Z, Y, i);

            printf(" +0  ");

            printf("partMul: %s ", tempXY);
            printf("\n");
            printf("  +   ");
            print0();
            printf("\n");
        }
        else if (Y[b] < yb_1)
        {
            char tempXY[70] = {'\0'};
            XYprint(tempXY, Z, Y, i);

            Add(Z, X);
            printf(" +X  ");

            printf("partMul: %s ", tempXY);
            printf("\n");
            printf("  +   %s\n", X);
        }
        else
        {
            char tempXY[70] = {'\0'};
            XYprint(tempXY, Z, Y, i);

            Add(Z, _X);
            printf(" +_X ");

            printf("partMul: %s ", tempXY);
            printf("\n");
            printf("  +   %s\n", _X);
        }
        printf("  =   %s  ", Z);
        print(Y);
        printf("  %c\n", yb_1);

        // Y[] 与 Z[] 右移
        if (i < b)
        {
            printf("  rs  ");
            yb_1 = Y[b];
            for (int i = b; i > 0; --i)
                Y[i] = Y[i - 1];
            Y[0] = Z[a + 2];
            for (int i = a + 2; i > 0; --i)
            {
                if (i == 3)
                {
                    Z[i] = Z[i - 2];
                    continue;
                }
                if (i == 2)
                    continue;
                Z[i] = Z[i - 1];
            }
            printf("%s  ", Z);
            print(Y);
            printf("  %c ", yb_1);
        }
    }

    print("\n");

    char XY[70] = {'\0'};
    XYprint(XY, Z, Y, b);
    printf("x*y's complement: %s\n", XY);

    print2(XY, a + b + 2);

    deletePoint(XY);
    char XYhex[70] = {'\0'};
    Bs2Hs(XY, XYhex);
    printf("convert to hex: %s", XYhex);
}

int main()
{
    int x, y, n;

    printf("input x, y: ");

    scanf("%d %d", &x, &y);

    // x = 4660;
    // y = 4660;

    n = x;
    while (n)
    {
        ++a;
        n /= 2;
    }
    n = y;
    while (n)
    {
        ++b;
        n /= 2;
    }

    Booth(x, y);

    return 0;
}
