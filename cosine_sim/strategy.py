#!/usr/bin/env python3


import enum


Predicates = enum.Enum('predicates',

    [
        'hasStateInName',
        'hasChStBeenCalledManyTimes',
        'getChSt',
        'getStrategyInterfaces',
        'getStrictStrategyInterfaces',
        'getContextClasses',
    ],

    start = 0

)
