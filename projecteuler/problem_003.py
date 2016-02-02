#!/usr/bin/env python2.7
# encoding: utf-8

import math


def prime(end):
    for i in xrange(2, end+1):
        flag = True
        for j in xrange(2, int(math.sqrt(i))+1):
            if i % j == 0:
                flag = False
        if flag:
            yield i


def prime_factor(number):
    n = number
    k = 1
    while n != 1:
        for k in prime(number):
            if n % k == 0:
                yield k
                n = n / k
                break


if __name__ == '__main__':
    m = 0
    for i in prime_factor(13195):
        m = max(m, i)
    print m

    m = 0
    for i in prime_factor(600851475143):
        m = max(m, i)
    print m

