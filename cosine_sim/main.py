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


def main(argv, f=None):

    global Predicates, Vecdim

    if len(argv) != 3:
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
        # print(mapping[class_name])
        class_vec = construct_vector(mapping[class_name])
        similarity = cosine_sim.cosine_sim(class_vec, [1] * Vecdim)
        # print(class_name, class_vec)
        if similarity > 0.70:
            if f is not None:
                print('{}: {} => {:.3f}'.format(pattern, class_name,
                                                similarity),
                      file=f, flush=True)
            else:
                print('{}: {} => {:.3f}'.format(pattern, class_name, similarity))

    return 0


if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
