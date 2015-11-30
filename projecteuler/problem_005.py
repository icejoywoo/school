#!/usr/bin/env python2.7
# encoding: utf-8

from __future__ import division
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
    all_prime = {}
    for i in range(2, 21):
        prime_counter = {}
        for j in prime_factor(i):
            prime_counter.setdefault(j, 0)
            prime_counter[j] += 1
        for k, v in prime_counter.items():
            if all_prime.get(k, 0) < v:
                all_prime[k] = v
    print all_prime

    r = reduce(lambda x, y: x * y, [k**v for k, v in all_prime.items()])

    for i in range(1, 21):
        print i, r / i
    print r

