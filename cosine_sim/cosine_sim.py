#!/usr/bin/env python3


def cosine_sim(v1, v2):

    if len(v1) != len(v2):
        raise ValueError('Vectors not of equal length')

    l = len(v1)
    num = 0
    dem1 = 0
    dem2 = 0
    for i in range(l):
        num += v1[i] * v2[i]
        dem1 += v1[i] ** 2
        dem2 += v2[i] ** 2

    return num / (dem1 * dem2) ** 0.5
