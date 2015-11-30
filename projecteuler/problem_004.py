#!/usr/bin/env python2.7
# encoding: utf-8


def is_palindrome(n):
    s = str(n)
    l = len(s)
    p = 0
    q = l - 1
    while p <= q:
        if s[p] == s[q]:
            p += 1
            q -= 1
        else:
            return False
    return True


if __name__ == '__main__':
    exit_flag = False
    for i in xrange(999*999, 1, -1):
        if is_palindrome(i):
            for j in xrange(999, 99, -1):
                if i % j == 0:
                    o = i / j
                    if 100 <= o <= 999:
                        print i, j, i/j
                        exit_flag = True
                        break
        if exit_flag:
            break

