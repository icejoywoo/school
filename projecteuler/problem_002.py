#!/usr/bin/env python2.7
# encoding: utf-8

from __future__ import division, print_function


def fibonacci(end):
    a, b = 1, 2
    yield a
    yield b
    while True:
        a, b = b, a + b
        if b < end:
            yield b
        else:
            break

if __name__ == '__main__':
    print(list(fibonacci(10)))
    print(sum((i for i in fibonacci(4000000) if i % 2 == 0)))
