#!/usr/bin/env python2.7
# encoding: utf-8


if __name__ == '__main__':
    s = sum(range(1, 101)) ** 2
    ss = sum((i**2 for i in range(1, 101)))
    print s, ss
    print s - ss

