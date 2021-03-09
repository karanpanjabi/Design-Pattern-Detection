#!/usr/bin/env python3


import enum

import classmap
import cosine_sim


predicates = enum.Enum('predicates',

    [
        'hasMemberFunctionWithStaticVar',
        'hasNoFriends',
        'hasRestrictedConstructors',
        'hasStaticFunctionWithSameReturn',
        'hasStaticVariableWithSameType',
    '_'],

    start = 0

)


def construct_vector(preds):

    # 5 because we have only 5 predicates rn
    vec = [ 0 for i in range(5) ]

    for pred in preds:
        vec[predicates[pred].value] = 1

    return vec


def main(argv):

    if not len(sys.argv) > 1:
        print('Provide directory with JSON files as the last argument',
              file=sys.stderr)
        return 1

    json_path = argv.pop()
    json_to_class_mapper = classmap.OutputJSONDir(json_path)

    mapping = json_to_class_mapper.load()

    for className in mapping:
        class_vec = construct_vector(mapping[className])
        similarity = round(cosine_sim.cosine_sim(
                             class_vec, [ 1 for i in range(5) ]), 3)
        if similarity > 0.75:
            print(className, '=>', similarity)

    return 0


if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
