#!/usr/bin/env python2.7
# encoding: utf-8

import math


def is_prime(number):
    for j in xrange(2, int(math.sqrt(number))+1):
        if number % j == 0:
            return False
    return True


def prime():
    n = 2
    while True:
        if is_prime(n):
            yield n
        n += 1


def get_prime(index):
    p = prime()
    for i in range(index-1):
        p.next()
    return p.next()


if __name__ == '__main__':
    print get_prime(6)
    print get_prime(10001)

