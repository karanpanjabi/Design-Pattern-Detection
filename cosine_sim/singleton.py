#!/usr/bin/env python3


import enum


Predicates = enum.Enum('predicates',

    [
        'hasMemberFunctionWithStaticVar',
        'hasNoFriends',
        'hasRestrictedConstructors',
        'hasStaticFunctionWithSameReturn',
        'hasStaticVariableWithSameType',
    ],

    start = 0

)
