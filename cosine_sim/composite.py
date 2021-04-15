#!/usr/bin/env python3


import enum


Predicates = enum.Enum('predicates',

    [
        'hasCompositeChildren',
        'hasArrayOrVectorChildren',
        'hasAggregateChildren',
        'hasCompositeOperation',
    ],

    start = 0

)
