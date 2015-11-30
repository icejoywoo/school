#!/usr/bin/env python2.7
# encoding: utf-8

from __future__ import division, print_function


def get_number():
    number = yield
    while True:
        if number % 3 == 0 or number % 5 == 0:
            number = yield number
        else:
            number = yield 0


def sum_all(end):
    s = 0
    gen = get_number()
    gen.send(None)
    for i in range(end):
        s += gen.send(i)
    return s

if __name__ == '__main__':
    print(sum_all(10))
    print(sum_all(1000))
    print(sum((i for i in range(1000) if i % 3 == 0 or i % 5 == 0)))
