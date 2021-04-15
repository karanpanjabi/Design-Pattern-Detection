#!/usr/bin/env python3


import enum


Predicates = enum.Enum('predicates',

    [
        'hasNotifyDefinition',
        'updateFunctionAccessesSubject',
    ],

    start = 0

)
