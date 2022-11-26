+++
author = "soli"
title = "codeforces practices"
date = "2022-11-25"
description = ""
categories = ["codeforces"]
tags = ["codeforces"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img7.png"
+++
<!--more-->
## 栽在了简单数学题上
[Codeforces Round #836 (Div. 2) B题目链接](https://codeforces.com/contest/1758/problem/B)<br>
反思：<br>
其实就是((n-1)*(n+1)+1)/n=n。。。对简单数学不够敏感哎<br>
题目意思没理解对，误以为𝑎1+𝑎2+⋯+𝑎𝑛求和可以不整除𝑛。。。
{{< highlight cpp "linenos=table" >}}
#include <stdio.h>
#include <iostream>
#include <string>
#include <algorithm>
using namespace std;
int main()
{
    int t, n;
    scanf("%d", &t);
    while (t--)
    {
        scanf("%d", &n);
        if (n & 1)
        {
            for (int i = 1; i <= n; i++)
            {
                printf("%d",n);
                if(i!=n){
                    printf(" ");
                }
            }
            printf("\n");
            continue;
        } else {
            printf("1");
            for (int i = 1; i <= n-1; i++)
            {
                printf(" %d",n+1);
            }
            printf("\n");
        }
    }
    return 0;
}
{{< / highlight >}}