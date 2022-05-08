#include <stdio.h>

int main(void)
{
    int num = 7; // 二进制数 7
    int square = 0;

    int i = 0;
    for (i = 0; i < 8; i++)
        if (num & (1 << i))
            square += (num << i);

    printf("%d\n", square);

    return 0;
}
