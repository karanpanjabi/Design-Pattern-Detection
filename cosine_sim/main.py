#!/usr/bin/env python3


import classmap
import cosine_sim


Predicates = None
Vecdim = None


def construct_vector(preds):

    vec = [0] * Vecdim

    for pred in preds:
        try:
            vec[Predicates[pred].value] = 1
        except KeyError:
            pass

    return vec


def main(argv):

    global Predicates, Vecdim

    if len(argv) < 2 or len(argv) > 3:
        print('usage: {} <JSON directory path> <Pattern name>'.format(argv[0]),
              file=sys.stderr)
        return 1

    pattern = argv[2]
    if pattern == 'singleton':
        import singleton
        Predicates = singleton.Predicates
    elif pattern == 'composite':
        import composite
        Predicates = composite.Predicates
    elif pattern == 'adapter':
        import adapter
        Predicates = adapter.Predicates
    elif pattern == 'absfact':
        import absfact
        Predicates = absfact.Predicates
    elif pattern == 'observer':
        import observer
        Predicates = observer.Predicates
    elif pattern == 'command':
        import command
        Predicates = command.Predicates
    elif pattern == 'strategy':
        import strategy
        Predicates = strategy.Predicates
    else:
        raise NotImplementedError('are you sure that\'s a pattern?')

    Vecdim = len(Predicates)

    json_path = argv[1]
    json_to_class_mapper = classmap.OutputJSONDir(json_path)

    mapping = json_to_class_mapper.load()

    for class_name in mapping:
        class_vec = construct_vector(mapping[class_name])
        similarity = cosine_sim.cosine_sim(class_vec, [1] * Vecdim)
        if similarity > 0.75:
            print('{} => {:.3f}'.format(class_name, similarity))

    return 0


if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
