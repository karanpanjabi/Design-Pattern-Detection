#!/usr/bin/env python3


import enum


Predicates = enum.Enum('predicates',

    [
        'getCommandClasses',
        'getStrictCommandClasses',
        'hasCallToReceiver',
    ],

    start = 0

)
